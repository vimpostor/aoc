(* risk_level * distance from (0,0) *)
type node = N of int * int;;
(* We map from coordinates to Nodes *)
type coord = {x: int; y: int};;
module CMap = Map.Make(struct type t = coord let compare = compare end);;

let explode s = List.init (String.length s) (String.get s) in

let rec build lines x y = match lines with
    | [] -> CMap.empty
    | [] :: ls -> build ls 0 (y + 1)
    | (b :: bs) :: ls -> CMap.add {x;y} (N (Char.code b - 48, 0)) (build (bs :: ls) (x + 1) y)
in

let step (N (h,_)) dist = N (h,dist + h) in

let find_min {x; y} (N (_,d)) (a,b,c) = if d < c then (x,y,d) else (a,b,c) in

let rec add_bounded nodes length neighs = match neighs with
    | n :: ns -> if (n.x < 0 || n.x >= length || n.y < 0 || n.y >= length || not(CMap.mem n nodes)) then add_bounded nodes length ns else CMap.add n (CMap.find n nodes) (add_bounded nodes length ns)
    | [] -> CMap.empty
in

let neighbors x y nodes length = add_bounded nodes length [{x=x+1;y=y};{x=x-1;y=y};{x=x;y=y+1};{x=x;y=y-1}] in

let merge_help k xo yo = match xo,yo with
    | Some N (a,b), Some N (c,d) -> if b < d then Some (N (a,b)) else Some (N (c,d))
    | None, yo -> yo
    | xo, None -> xo
in

(* recursive Dijkstra! :) *)
let rec dijkstra nodes next length =
    if CMap.is_empty next then CMap.empty else
        let (x,y,d) = CMap.fold find_min next (-1,-1,100000) in
        let neigh = CMap.map (fun n -> step n d) (neighbors x y nodes length) in
        CMap.add {x;y} (N (0,d)) (dijkstra (CMap.remove {x=x;y=y} nodes) (CMap.merge merge_help neigh (CMap.remove {x=x;y=y} next)) length)
in

let inc (N (x, a)) = N ((x + 1) mod 10 + Bool.to_int (x == 9), a) in

let rec shift nodes offx offy =
    if CMap.is_empty nodes then CMap.empty else
        let ({x;y},v) = CMap.min_binding nodes in
        CMap.add {x=x+offx;y=y+offy} v (shift (CMap.remove {x;y} nodes) offx offy)
in

let rec expandy nodes times offset =
    let i = shift (CMap.map inc nodes) 0 offset in
    if times == 0 then CMap.empty else CMap.merge merge_help nodes (expandy i (times - 1) offset)
in

let rec expand nodes times timesy offset =
    let i = shift (CMap.map inc nodes) offset 0 in
    if times == 0 then CMap.empty else CMap.merge merge_help (expandy nodes timesy offset) (expand i (times - 1) timesy offset)
in

let rec solve g width expand_fs = match expand_fs with
    | [] -> []
    | expand_f :: rest -> let grid = expand g expand_f expand_f width in
                          let start = {x=0;y=0} in
                          let res = dijkstra grid (CMap.add start (CMap.find start grid) CMap.empty) (expand_f * width) in
                          let N (_, value) = (CMap.find {x=(expand_f * width - 1); y=(expand_f * width - 1)} res) in
                          value :: solve grid width rest
in

(* parse the input *)
let lines =
    let c = open_in "input.txt" in
    really_input_string c (in_channel_length c) |> String.split_on_char '\n' |> List.map explode
in
let expand_fs = [1;5] in
let width = List.length lines - 1 in
let grid = build lines 0 0 in
let res = solve grid width expand_fs in
List.iter (fun x -> print_endline (Int.to_string x)) res
