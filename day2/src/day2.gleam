import gleam/bool
import gleam/list
import gleam/io
import gleam/string
import gleam/int
import simplifile

pub fn main() {
  let assert Ok(data) = "pt1.txt" |> simplifile.read
  let data = string.split(data, "\n")
    |> list.filter(fn(l) { string.length(l) > 0 })
    |> parse([])

  let pt1_safe = data |> list.map(is_safe)

  let safe_count = pt1_safe |> list.count(fn (e) {e})
  io.println("pt1: " <> int.to_string(safe_count))

  let pt2_safe = data |> list.map(is_safe_with_dampener)
  let pt2_safe_count = pt2_safe |> list.count(fn (e) {e})
  io.println("pt2: " <> int.to_string(pt2_safe_count))
}

pub fn parse(
  lines: List(String),
  acc: List(List(Int)),
) -> List(List(Int)) {
  case lines {
    [line, ..rest] -> {
      let parts = string.split(line, " ") |> list.map(fn (e) {
        let assert Ok(data) = int.parse(e)
        data
      })
      parse(rest, list.append(acc, [parts]))
    }
    [] -> acc
  }
}

pub fn is_safe_with_dampener(sample: List(Int)) -> Bool {
  case is_safe(sample) {
    True -> True
    False -> {
      // Try removing each element one at a time
      list.range(0, list.length(sample) - 1)
      |> list.map(fn(i) {
        drop(sample, i)
        |> is_safe
      })
      |> list.contains(True)
    }
  }
}

pub fn is_safe(sample: List(Int)) -> Bool {
  one_change(sample) && is_safe_delta_loop(sample)
}

pub fn one_change(sample: List(Int)) ->  Bool {
  bool.exclusive_or(only_increasing(sample), only_decreasing(sample))
}

pub fn only_increasing(sample: List(Int)) -> Bool {
  sample |> list.window(2) |> list.map(fn (e) {
    let assert [a, b] = e
    let delta = b - a
    delta <= 0
  }) |> list.contains(False)
}

pub fn only_decreasing(sample: List(Int)) -> Bool {
  sample |> list.window(2) |> list.map(fn (e) {
    let assert [a, b] = e
    let delta = b - a
    delta >= 0
  }) |> list.contains(False)
}

pub fn is_safe_delta_loop(sample: List(Int)) -> Bool {
  case sample {
    [a, b, ..rest] -> {
      case int.absolute_value(a-b) {
        // within operating range
        1 | 2 | 3 -> is_safe_delta_loop([b, ..rest])
        // unsafe!
        _ -> False // any other change
      }
    }
    [_] -> True // assume the sample is safe if we made it to the end
    [] -> True
  }
}

pub fn drop(list: List(a), index: Int) -> List(a) {
  case index {
    0 -> list.drop(list, 1)
    _ -> {
      list.take(list, index)
      |> list.append(list.drop(list, index + 1))
    }
  }
}
