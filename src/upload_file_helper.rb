module UploadFileHelper
  include FileUtils::Verbose

  def upload_file(params, name)
    tempfile = params[name][:tempfile]
    filename = params[name][:filename]
    path = "uploads/#{filename}"
    cp(tempfile.path, path)
    path
  end
end
