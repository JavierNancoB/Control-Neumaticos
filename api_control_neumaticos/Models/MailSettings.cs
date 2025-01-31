namespace SendingEmails
{
    public class MailSettings
    {
        public required string SmtpServer { get; set; }
        public required int SmtpPort { get; set; }
        public required string SmtpUser { get; set; }
        public required string SmtpPassword { get; set; }
    }
}
