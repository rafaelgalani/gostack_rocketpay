# Rocketpay API

A simple API to handle bank account transactions. Developed with Elixir, with Phoenix and Ecto. Excoveralls is used to handle tests.

### Requirements
 - Elixir (`>= 1.7`);
 - A local PostgreSQL instance.

_P.S: (Mac/Linux users can use [asdf](https://asdf-vm.com/) for a quicker installation and a better programming language version management/control. You can use [this guide](https://gist.github.com/rubencaro/6a28138a40e629b06470) to install elixir using asdf.)_

To start the server, run the folllowing commands:

- `$ mix deps.get`
- `$ mix ecto.setup`
- `$ mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

### Routes

#### User
- ##### `POST /api/users` 
  
  Creates an user with the specified data. It will also return an `account`, which will be used in the `/api/accounts/*` operations.
  
  ##### Payload:
  ```json
  {
    "name": "name",
    "password": "password",
    "nickname": "nickname",
    "email": "example@mail.com",
    "age": 23
  }
  ```
  
  ##### Response:
  ```json
  {
    "id": "user generated uuid",
    "name": "name",
    "password_hash": "the provided password, but hashed",
    "nickname": "nickname",
    "email": "example@mail.com",
    "age": 23,
    "account": {
      "id": "account generated uuid",
      "balance": "0.00"
    }
  }
  ```
#### Account

All operations in the `/api/accounts/` path require authentication. Authentication was setup with [Basic Authentication](https://en.wikipedia.org/wiki/Basic_access_authentication):

```
username: Rafael
password: password
```
- ##### `POST /api/accounts/:id/deposit` 
  
  Deposits a specified amount from the account with the specified `id` route param.
  
  ##### Payload:
  ```json
  {
    "value": "20.00",
  }
  ```
  
  ##### Response:
  ```json
  {
    "account": {
      "balance": "20.00", 
      "id": "account uuid"
    }, 
    "message": "Balance changed successfully."
  }
  ```
- ##### `POST /api/accounts/:id/withdraw` 
  
  Withdraws a specified amount from the account with the specified `id` route param.
  
  ##### Payload:
  ```json
  {
    "value": "20.00",
  }
  ```
  
  ##### Response:
  ```json
  {
    "account": {
      "id": "account generated uuid",
      "balance": "0.00"
    },
    "message": "Balance changed successfully."
  }
  ```
- ##### `POST /api/accounts/transaction` 
  
  Transfers the specified amount between the specified accounts. Response the updated balance for both accounts.
  ##### Payload:
  ```json
  {
    "from_id": "1",
    "to_id": "2",
    "value": "20.00",
  }
  ```
  
  ##### Response:
  ```json
  {
    "message": "Transaction successful.",
    "transaction": {
      "from_account": {
        "id": "1",
        "balance": "0.00"
      },
      "to_account": {
        "id": "2",
        "balance": "20.00"
      }
    }
  }
  ```

### To learn more about Elixir and Phoenix

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
