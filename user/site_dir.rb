dep 'cb site dir' do
  requires 'cb account'
  met? { File.exist?('/home/'+var(:username)+'/'+var(:primary_domain)) }
  meet {
    sudo 'mkdir /home/'+var(:username)+'/'+var(:primary_domain)
    sudo 'chown '+var(:username)+':'+var(:username)+' /home/'+var(:username)+'/'+var(:primary_domain)
  }
end
