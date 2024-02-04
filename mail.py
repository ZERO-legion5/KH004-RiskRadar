import smtplib
# creates SMTP session
s = smtplib.SMTP('smtp.gmail.com', 587)
# start TLS for security
s.starttls()
# Authentication
s.login("emailalerts76@gmail.com", "dyul espr lymt wjwa")
# message to be sent
message = "No"
# sending the mail
s.sendmail("emailalerts76@gmail.com", "zerolegion5@gmail.com", message)
# terminating the session
s.quit()