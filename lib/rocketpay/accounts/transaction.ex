defmodule Rocketpay.Accounts.Transaction do
  alias Ecto.Multi

  alias Rocketpay.Accounts.Operation
  alias Rocketpay.Repo

  def call(%{"from_id" => from_id, "to_id" => to_id, "value" => value}) do
    Multi.new()
    |> Multi.merge(fn _changes -> Operation.call(build_params(from_id, value), :withdraw) end)
    |> Multi.merge(fn _changes -> Operation.call(build_params(to_id, value), :deposit) end)
    |> run_transaction
  end

  defp run_transaction(multi) do
    case Repo.transaction(multi) do
      {:error, _operation, reason, _changes} -> {:error, reason}
      {:ok, %{account_deposit: to_account, account_withdraw: from_account}} -> {:ok, %{to_account: to_account, from_account: from_account}}
    end
  end

  defp build_params(id, value), do: %{"id" => id, "value" => value}
end
