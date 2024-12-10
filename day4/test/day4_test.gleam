import day4
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn hello_world_test() {
  1
  |> should.equal(1)
}

pub fn string_count_occurrences_test() {
  day4.count_occurrences(in: "hello hello world", of: "hello")
  |> should.equal(2)
}
