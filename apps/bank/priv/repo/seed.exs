unless (Rsvp.UsersQueries.any) do
    Rsvp.EventQueries.create(Rsvp.Events.changeset(%Rsvp.Events{}, %{date: "2019-05-23 09:00:00", title: "Summer Codefest", location: "Omaha, NE"}))
    Rsvp.EventQueries.create(Rsvp.Events.changeset(%Rsvp.Events{}, %{date: "2019-06-19 00:00:00", title: "Charles Spurgeon's Birthday", location: "London"}))
end

unless (Rsvp.AccountsQueries.any) do
    Rsvp.EventQueries.create(Rsvp.Events.changeset(%Rsvp.Events{}, %{date: "2019-05-23 09:00:00", title: "Summer Codefest", location: "Omaha, NE"}))
    Rsvp.EventQueries.create(Rsvp.Events.changeset(%Rsvp.Events{}, %{date: "2019-06-19 00:00:00", title: "Charles Spurgeon's Birthday", location: "London"}))
end

unless (Rsvp.TransfersQueries.any) do
    Rsvp.EventQueries.create(Rsvp.Events.changeset(%Rsvp.Events{}, %{date: "2019-05-23 09:00:00", title: "Summer Codefest", location: "Omaha, NE"}))
    Rsvp.EventQueries.create(Rsvp.Events.changeset(%Rsvp.Events{}, %{date: "2019-06-19 00:00:00", title: "Charles Spurgeon's Birthday", location: "London"}))
end
