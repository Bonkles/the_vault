class VmtFilesController < ApplicationController
before_filter :assemble_oems

  def show
    id = params[:id] # retrieve vmt_file ID from URI route
    @vmt_file = VmtFile.find(id) # look up vmt_file by unique ID
    # will render app/views/vmt_files/show.<extension> by default
  end

#This method checks the database and assembles an instance variable array
#whose elements consist of the oems present.   
  def assemble_oems
    @all_oems = Hash.new
    oems_vmt_files = VmtFile.all
        oems_vmt_files.each do |vmt_file|
          unless @all_oems.keys.include? vmt_file.oem
            @all_oems[vmt_file.oem] = 1
      end
    end
    @oems_filter = @all_oems
  end
  
  def index
    #Assume we don't need to redirect the browser. 
    redirect = false
    if params.has_key? :oems
      #if they passed in a hash, we are only interested in the keys. This is what we get if we click the submit button in the top form. 
      @oems_filter = params[:oems]
      session[:oems] = params[:oems] #save these params in the session. 
    elsif session.has_key? :oems
        @oems_filter = session[:oems]
      #Since we didn't supply the string in the params, we need to provide a RESTful route!
        params[:oems] = session[:oems]
        redirect = true
    end

    #If oem or filename are passed, order the elements as such! 
    if params.has_key? :sort_by
      @sort_column = params[:sort_by]
      session[:sort_by] = @sort_column
    elsif session.has_key? :sort_by #If there was no key passed in via the URI, use the session info instead.
      @sort_column = session[:sort_by]      
      params[:sort_by] = session[:sort_by]      
      redirect = true
    end

    if redirect
      flash.keep
      redirect_to params
    end

    vmt_file_query = VmtFile.where(:oem => @oems_filter.keys)
    if (@sort_column == nil)
      @vmt_files = vmt_file_query.all
    else
      @vmt_files = vmt_file_query.order(@sort_column).all
    end
    
    @vmt_files
  end

  def new
    # default: render 'new' template
  end

  def create
    @vmt_file = VmtFile.create!(params[:vmt_file])
    flash[:notice] = "#{@vmt_file.filename} was successfully created."
    redirect_to vmt_files_path
  end

  def edit
    @vmt_file = VmtFile.find params[:id]
  end

  def update
    @vmt_file = VmtFile.find params[:id]
    @vmt_file.update_attributes!(params[:vmt_file])
    flash[:notice] = "#{@vmt_file.filename} was successfully updated."
    redirect_to vmt_file_path(@vmt_file)
  end

  def destroy
    @vmt_file = VmtFile.find(params[:id])
    @vmt_file.destroy
    flash[:notice] = "VMT file '#{@vmt_file.filename}' deleted."
    redirect_to vmt_files_path
  end

end
