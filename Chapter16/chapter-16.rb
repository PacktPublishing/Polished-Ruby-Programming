### 16
### Web Application Design Principles

## Deciding on a web framework

require 'sinatra'
get('/'){'Hello World'}

# --

require 'roda'
Roda.route do |r|
  r.root{'Hello World'}
end

## Designing URL paths

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

# --

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

# --

    r.on 'topics', Integer do |topic_id|
      topic = Topic[topic_id]
      unless topic.forum.allow_access?(current_user_id)
        response.status = 403
        r.halt
      end

      unless topic.allow_access?(current_user_id)
        response.status = 403
        r.halt
      end

      # ...
    end
  end
end
