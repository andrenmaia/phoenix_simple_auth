defmodule SimpleAuth.SessionController do
    use SimpleAuth.Web, :controller

    import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

    alias SimpleAuth.User
    alias SimpleAuth.Auth

    plug :scrub_params, "session" when action in ~w(create)a

    def new(conn, _) do
        render conn, "new.html"
    end

    def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
        case Auth.login_by_email_and_pass(conn, email, password) do
            {:ok, conn} -> 
                conn
                |> put_flash(:info, "Your're now logged in!")
                |> redirect(to: page_path(conn, :index))
            {:error, _reason, conn} ->
                conn 
                |> put_flash(:error, "Invalid email/password combination")
                |> render("new.html")
            
        end
    end
    
    def delete(conn, _) do
        conn
        |> Auth.logout
        |> put_flash(:info, "See you later")
        |> redirect(to: page_path(conn, :index))
    end

end