require 'googleauth'
require 'byebug'
require 'google/apis/drive_v3'

template_path = './template.docx'

Drive = ::Google::Apis::DriveV3
drive = Drive::DriveService.new

# :copy_file,

auth = ::Google::Auth::ServiceAccountCredentials
  .make_creds(scope: 'https://www.googleapis.com/auth/drive')
drive.authorization = auth

byebug

list_files = drive.list_files()


# update template
file_metadata = {name: 'template.docs'}
file = drive.create_file(file_metadata, fields: 'id', upload_source: template_path, content_type: '*/*')

# find template
template_file_id = "147AqVUyuc0WiqrolBzW_dAYl3Cb3wdPc"
template_file = drive.get_file(template_file_id)
# copy template
