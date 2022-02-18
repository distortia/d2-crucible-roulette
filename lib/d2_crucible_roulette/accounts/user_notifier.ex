defmodule D2CrucibleRoulette.Accounts.UserNotifier do
  import Swoosh.Email

  alias D2CrucibleRoulette.Mailer

  @moduledoc """
  UserNotifier handles all user notification emails regarding a user's account
  """

  # Delivers the email using the application mailer.
  defp deliver(recipient, subject, body) do
    sender_email =
      System.get_env("SENDGRID_EMAIL_ADDRESS") || "noreply@d2crucibleroulette.fly.dev"

    email =
      new()
      |> to(recipient)
      |> from({"D2 Crucible Roulette", sender_email})
      |> subject(subject)
      |> text_body(body)

    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_confirmation_instructions(user, url) do
    deliver(user.email, "Confirmation instructions", """

    ==============================

    Hi #{user.email},

    You can confirm your account by visiting the URL below:

    #{url}

    If you didn't create an account with us, please ignore this.

    ==============================
    """)
  end

  @doc """
  Deliver instructions to reset a user password.
  """
  def deliver_reset_password_instructions(user, url) do
    deliver(user.email, "Reset password instructions", """

    ==============================

    Hi #{user.email},

    You can reset your password by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """)
  end

  @doc """
  Deliver instructions to update a user email.
  """
  def deliver_update_email_instructions(user, url) do
    deliver(user.email, "Update email instructions", """

    ==============================

    Hi #{user.email},

    You can change your email by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """)
  end
end
