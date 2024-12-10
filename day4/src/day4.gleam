import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile

pub fn main() {
  let assert Ok(data) = "ex1.txt" |> simplifile.read
  // dumb idea... just count the occurances of "XMAS" in the string
  // dealing with reverse is super easy... just reverse the row (also helps with double counting)
  //
  // then do the same thing for columns
  // then also with rows

  // SAMPLE:
  // ....XXMAS. | .SAMXX.... | Found 1 match in og row
  // .SAMXMS... | ...SMXMAS. | found 1 match in reversed

  let horizontal_count =
    data
    |> string.split("\n")
    |> count_xmas_and_rev
    |> label("- -")

  let vertical_count =
    data
    |> string.split("\n")
    |> list.map(fn(e) { e |> string.to_graphemes })
    |> list.transpose
    |> list.map(fn(l) { l |> string.join("") })
    |> count_xmas_and_rev
    |> label("| -")

  // now we shift the whole string over to create the diagonals and
  // then rotate the whole thing

  let backwards_diag_count =
    data
    |> string.split("\n")
    |> list.index_map(fn(row, amt) {
      let len = row |> string.length

      let ending_pad = { len * 2 } - amt - len
      string.repeat(".", amt)
      |> string.append(row)
      |> string.append(string.repeat(".", ending_pad))
    })
    |> list.map(fn(e) { e |> string.to_graphemes })
    |> list.transpose
    |> list.map(fn(l) { l |> string.join("") })
    |> count_xmas_and_rev
    |> label("\\ -")

  let forwards_diag_count =
    data
    |> string.split("\n")
    |> list.index_map(fn(row, amt) {
      let len = row |> string.length

      let starting_pad = { len * 2 } - amt - len
      string.repeat(".", starting_pad)
      |> string.append(row)
      |> string.append(string.repeat(".", amt))
    })
    |> list.map(fn(e) { e |> string.to_graphemes })
    |> list.transpose
    |> list.map(fn(l) { l |> string.join("") })
    |> count_xmas_and_rev
    |> label("/ -")

  io.println(
    "pt1: "
    <> int.to_string(
      vertical_count
      + horizontal_count
      + forwards_diag_count
      + backwards_diag_count,
    ),
  )
}

pub fn count_xmas_and_rev(data: List(String)) -> Int {
  data
  |> list.map(fn(e) { [e, e |> string.reverse] })
  |> list.flatten
  |> list.map(fn(row) { row |> count_occurrences("XMAS") })
  |> list.fold(0, int.add)
}

pub fn label(o: a, label: String) -> a {
  io.println(label <> " " <> string.inspect(o))
  o
}

pub fn count_occurrences(in text: String, of substring: String) -> Int {
  case string.length(substring) {
    0 -> 0
    substring_len ->
      case string.length(text) {
        0 -> 0
        text_len if text_len < substring_len -> 0
        _ -> {
          let start = string.slice(text, 0, substring_len)
          let rest = string.slice(text, 1, string.length(text))
          case start == substring {
            True -> 1 + count_occurrences(in: rest, of: substring)
            False -> count_occurrences(in: rest, of: substring)
          }
        }
      }
  }
}
