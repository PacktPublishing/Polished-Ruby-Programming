class App < Roda
  route do |r|
    r.on 'forums', Integer do |forum_id|
      forum = Forum[forum_id]
      unless forum.allow_access?(current_user_id)
        response.status = 403
        r.halt
      end

      # ...
    end
  end
end
