Baz.class_eval "def #{name}; :foo end"

if /\A[A-Za-z_][A-Za-z0-9_]*\z/.match?(name)
  Baz.class_eval "def #{name}; :foo end"
else
  Baz.define_method(name){:foo}
end
