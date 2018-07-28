defmodule UserRestfulapiPhxWeb.StripeController do
  use UserRestfulapiPhxWeb, :controller
  action_fallback(MyApiWeb.FallbackController)

  def create(conn, %{
        "description" => description,
        "email" => email,
        "source" => source,
        "subscriptionID" => subscriptionID
      }) do
    with {:ok, stripeUser} <-
           Stripe.Customer.create(%{description: description, email: email, source: source}) do
      IO.inspect(stripeUser.id)

      with {:ok, stripesub} <-
             Stripe.Subscription.create(%{customer: stripeUser.id, plan: subscriptionID}) do
        IO.inspect(stripesub.id)
        send_resp(conn, 200, [])
      else
        unmatched ->
          IO.inspect(unmatched, label: "unmatched")
      end
    else
      unmatched ->
        IO.inspect(unmatched, label: "unmatched")
    end
  end

  def delete(conn, %{
        "subscriptionID" => subscriptionID
      }) do
    IO.inspect(subscriptionID)

    with {:ok, x} <- Stripe.Subscription.delete(%{id: subscriptionID}) do
      IO.inspect(x)
      send_resp(conn, 200, [])
    end
  end
end
