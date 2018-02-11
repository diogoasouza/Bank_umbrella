unless (Bank.UsersQueries.any) do
    Bank.UsersQueries.create(Bank.Users.changeset(%Bank.Users{}, %{name: "Diogo", email: "diogo.asouza@gmail.com", password: "123"}))
    Bank.UsersQueries.create(Bank.Users.changeset(%Bank.Users{}, %{name: "Matheus", email: "matheus@gmail.com", password: "abc"}))
    Bank.UsersQueries.create(Bank.Users.changeset(%Bank.Users{}, %{name: "Teste", email: "teste@gmail.com", password: "123"}))
end

unless (Bank.AccountsQueries.any) do
    Bank.AccountsQueries.create(Bank.Accounts.changeset(%Bank.Accounts{}, %{balance: "2000", currency: "BRL", owner: 1}))
    Bank.AccountsQueries.create(Bank.Accounts.changeset(%Bank.Accounts{}, %{balance: "10000", currency: "BRL", owner: 2}))
    Bank.AccountsQueries.create(Bank.Accounts.changeset(%Bank.Accounts{}, %{balance: "10000", currency: "USD", owner: 3}))
end

unless (Bank.TransfersQueries.any) do
    Bank.TransfersQueries.create(Bank.Transfers.changeset(%Bank.Transfers{}, %{amount: "1000", currency: "BRL", to: 1, from: 2, date: "2019-05-23 09:00:00"}))
    Bank.TransfersQueries.create(Bank.Transfers.changeset(%Bank.Transfers{}, %{amount: "100", currency: "BRL", to: 2, from: 1, date: "2019-05-23 09:00:00"}))
end
