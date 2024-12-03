import gleam/dict
import gleam/int.{absolute_value}
import gleam/io
import gleam/list
import gleam/option.{None, Some}
import gleam/string
import simplifile

pub fn main() {
  let filename = "pt1.txt"
  let assert Ok(data) = simplifile.read(filename)
  let lines = string.split(data, "\n") |> list.filter(fn(l) { string.length(l) > 0 })

  let left = lines
    |> parse(list.first, [])
    |> list.sort(by: int.compare)
  let right = lines
    |> parse(list.last, [])
    |> list.sort(by: int.compare)

  let diffs = list.map2(left, right, fn(l, r) { absolute_value(l - r) })

  let sum = list.fold(diffs, 0, int.add)

  io.println("pt1: " <> int.to_string(sum))

  let counts = count_items(right, dict.new())
  let sum =
    list.fold(left, 0, fn(acc, a) {
      case dict.get(counts, a) {
        Error(_) -> acc + { a * 0 }
        Ok(times) -> acc + { a * times }
      }
    })
  io.println("pt2: " <> int.to_string(sum))
}

pub fn parse(
  lines: List(String),
  col_getter: fn(List(String)) -> Result(String, Nil),
  acc: List(Int),
) -> List(Int) {
  case lines {
    [line, ..rest] -> {
      let parts = string.split(line, " ")
      let assert Ok(col) = col_getter(parts)
      let assert Ok(data) = int.parse(col)
      parse(rest, col_getter, [data, ..acc])
    }
    [] -> acc
  }
}

pub fn count_items(items: List(a), d: dict.Dict(a, Int)) -> dict.Dict(a, Int) {
  case items {
    [item, ..rest] -> {
      let d =
        dict.upsert(d, item, fn(x) {
          case x {
            Some(x) -> x + 1
            None -> 1
          }
        })
      count_items(rest, d)
    }
    [] -> d
  }
}
