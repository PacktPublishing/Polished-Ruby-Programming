Roda.route do |r|
  r.on "foo" do
    r.get "index" do
      # ...
    end
    # ...

    check_access

    r.get "create" do
      # ...
    end
    # ...
  end
end
