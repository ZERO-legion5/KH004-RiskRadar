import smtplib
from email.message import EmailMessage

sender = "emailalerts76@gmail.com"
receiver = "zerolegion5@gmail.com"

s = smtplib.SMTP('smtp.gmail.com', 587)
s.starttls()
s.login(sender, "dyul espr lymt wjwa")

em = EmailMessage()
em['From'] = sender
em['To'] = receiver
em['Subject'] = "Critical Level ALERT"
em.set_content('Data has been breached') 

s.sendmail(sender, receiver, em.as_string())
s.quit()