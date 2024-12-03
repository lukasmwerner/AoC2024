import day2
import gleeunit
import gleam/io
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn only_increasing_test() {
  [1,2,3,4,5]
    |> io.debug
    |> day2.only_increasing
    |> io.debug
    |> should.equal(True)
  [1,2,3,3]
    |> day2.only_increasing
    |> should.equal(False)
  [1,2,3,1]
    |> day2.only_increasing
    |> should.equal(False)
}

pub fn only_increasing2_test() {
  [1,2,3,4,5]
    |> io.debug
    |> day2.only_increasing2
    |> io.debug
    |> should.equal(True)
  [1,2,3,3]
    |> day2.only_increasing2
    |> should.equal(True)
  [1,2,3,1]
    |> day2.only_increasing2
    |> should.equal(False)
}

pub fn only_decreasing_test() {
  [5,4,3,2,1]
    |> day2.only_decreasing
    |> should.equal(True)
  [3,3,2,1]
    |> day2.only_decreasing
    |> should.equal(False)
  [1,3,2,1]
    |> day2.only_decreasing
    |> should.equal(False)
}
