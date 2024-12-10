import disp
import gleam/int
import gleam/io
import gleam/list
import gleam/string
import glex
import simplifile

pub fn main() {
  let assert Ok(code) = "ex2.txt" |> simplifile.read

  let tokens =
    glex.new()
    |> glex.add_rule("do", "do\\(\\)")
    |> glex.add_rule("don't", "don't\\(\\)")
    |> glex.add_rule("mul", "mul\\(\\d{1,3},\\d{1,3}\\)")
    |> glex.build(code)
    |> glex.lex

  tokens |> glex.valid_only |> list.each(io.debug)

  let program =
    tokens
    |> glex.valid_only
    |> list.map(fn(tok) {
      case tok.0 {
        glex.EndOfFile -> NoOp
        glex.Ignored(_, _) -> NoOp
        glex.Invalid(_) -> NoOp
        glex.Valid(_, str) -> {
          case str {
            "do()" -> Do
            "don't()" -> Dont
            "mul(" <> rest -> {
              let assert Ok(parts) =
                rest
                |> string.drop_end(1)
                |> string.split_once(on: ",")
              let assert Ok(a) = int.parse(parts.0)
              let assert Ok(b) = int.parse(parts.1)
              Mul(a, b)
            }
            _ -> NoOp
          }
        }
      }
    })

  exec(program, pt1_eval)
  |> disp.label("pt1: ")

  exec(program, pt2_eval)
  |> disp.label("pt2: ")
}

pub type Statement {
  NoOp
  Do
  Dont
  Mul(x: Int, y: Int)
}

pub type State {
  Enabled(sum: Int)
  Disabled(sum: Int)
}

pub fn exec(
  program: List(Statement),
  evaler: fn(State, Statement) -> State,
) -> Int {
  program
  |> list.fold(Enabled(0), evaler)
  |> fn(e) { e.sum }
}

pub fn pt1_eval(state: State, inst: Statement) -> State {
  case inst {
    Mul(x, y) -> Enabled(state.sum + x * y)
    _ -> Enabled(state.sum)
  }
}

pub fn pt2_eval(state: State, inst: Statement) -> State {
  case inst {
    NoOp -> state
    Do -> Enabled(state.sum)
    Dont -> Disabled(state.sum)
    Mul(x, y) ->
      case state {
        Disabled(_) -> Disabled(state.sum)
        Enabled(_) -> Enabled(state.sum + x * y)
      }
  }
}
