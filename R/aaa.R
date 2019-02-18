httr::user_agent(
  sprintf(
    "wiglr package v%s: (<%s>)",
    utils::packageVersion("wiglr"),
    utils::packageDescription("wiglr")$URL
  )
) -> .WIGLRUA
