defmodule Rocketpay.NumbersTest do
  use ExUnit.Case, async: true

  alias Rocketpay.Numbers

  describe "sum_from_file/1" do
    test "When there is a file with the given name, returns the sum of numbers" do
      response = Numbers.sum_from_file("numbers")

      expected_response = {:ok, %{result: 37}}

      assert expected_response == response
    end

    test "When there is no file with the given name, returns the error" do
      response = Numbers.sum_from_file("banana")

      expected_response = {:error, %{message: "Invalid file"}}

      assert expected_response == response
    end
  end
end
