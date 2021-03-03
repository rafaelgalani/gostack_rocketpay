defmodule Rocketpay.Accounts.Operation do
  alias Ecto.Multi

  alias Rocketpay.Account

  def call(%{"id" => id, "value" => value}, operation) do
    operation_name = account_operation_name(operation)
    retrieve_name = "#{operation_name}_get" |> String.to_atom
    Multi.new()
    |> Multi.run(retrieve_name, fn repo, _changes -> get_account(repo, id) end )
    |> Multi.run(operation_name, fn repo, changes ->
      account = Map.get(changes, retrieve_name)

      update_balance(repo, account, value, operation)
    end )
  end

  defp get_account(repo, id) do
    case repo.get(Account, id) do
      nil -> {:error, "Account not found."}
      account -> {:ok, account}
    end
  end

  defp update_balance(repo, account, value, operation) do
    account
    |> operation(value, operation)
    |> update_account(repo, account)
  end

  defp operation(%Account{balance: balance}, value, operation) do
    value
    |> Decimal.cast
    |> handle_cast(balance, operation)
  end

  defp handle_cast({:ok, value}, balance, :deposit),  do: Decimal.add(balance, value)
  defp handle_cast({:ok, value}, balance, :withdraw), do: Decimal.sub(balance, value)

  defp handle_cast(:error, _balance, _operation), do: {:error, "Invalid value. Please use decimal values only."}

  defp update_account({:error, _reason} = error, _repo, _account), do: error
  defp update_account(value, repo, account) do
    account
    |> Account.changeset(%{balance: value})
    |> repo.update
  end

  defp account_operation_name(operation), do: "account_#{Atom.to_string(operation)}" |> String.to_atom
end
