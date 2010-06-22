dep 'cb account' do
  met? { grep(/^#{var(:username)}:/, '/etc/passwd') }
  meet {
    sudo 'adduser '+var(:username)+' --disabled-password --gecos ""'
    # Note that the crypted password is visible in process listings when running usermod,
    # as well as in the babushka logs of the user who ran it.
    # The password is entered as unmasked plain text into the terminal running babushka.
    range = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ./'
    salt = range.chars.to_a[rand(range.length)] + range.chars.to_a[rand(range.length)]
    sudo 'usermod -p '+var(:password).crypt(salt)+' '+var(:username)
  }
end
