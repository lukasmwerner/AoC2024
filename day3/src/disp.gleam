import gleam/io
import gleam/string

pub fn label(something: a, label: String) -> a {
  io.println(label <> string.inspect(something))
  something
}
