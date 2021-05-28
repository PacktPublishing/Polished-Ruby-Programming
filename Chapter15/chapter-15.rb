### 15
### The Database Is Key

## Treating the database as not just dumb storage

# SELECT first_name || ' ' || last_name FROM names;

# --

# SELECT first_name, last_name FROM names

# --

"#{row[:first_name]} #{row[:last_name]}"

## Choosing the model layer

tracks = 10
Album.where("num_tracks > ?", tracks).to_a

# --

tracks = 10
Album.where{num_tracks > tracks}.all

## Handling database and model errors

model_instance.save
# => trueor false

# --

model_instance.save
# => model
# or raise Sequel::ValidationFailed
