class CreditType < EnumerateIt::Base
  associate_values(
    :money           => 1,
    :job             => 2,
    :ads             => 3,
    :resume_download => 4,
    :sms_alert       => 5
  )
end