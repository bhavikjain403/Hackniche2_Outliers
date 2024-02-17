from twitter.account import Account

## sign-in with credentials
# email, username, password = None, None, None
# account = Account(email, username, password)

## or, resume session using cookies
# account = Account(cookies={"ct0": ..., "auth_token": ...})

## or, resume session using cookies (JSON file)
# account = Account(cookies='twitter.cookies')


# account.tweet('hello world', media=[
#     {'media': 'menu.jpg', 'alt': 'some alt text'}])