import smtplib
from email.mime.text import MIMEText

def send_mail(subject, body, to_email):
    msg = MIMEText(body)
    msg['Subject'] = subject
    msg['From'] = 'your@email.com'
    msg['To'] = to_email
    # Replace with actual SMTP server details
    with smtplib.SMTP('localhost') as server:
        server.send_message(msg)
