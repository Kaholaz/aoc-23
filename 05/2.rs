use std::fs;
use std::iter::zip;

fn transform(dst: usize, src: usize, range: usize, old_seed: usize, default: usize) -> usize {
    return if old_seed < src || src + range <= old_seed {
        default
    } else {
        old_seed - src + dst
    };
}

fn main() {
    let input = fs::read_to_string("input").unwrap();
    let mut lines = input.lines();

    let seed_str = lines.next().unwrap();
    let mut seed_vec = vec![];
    let mut prev = None::<usize>;
    for u in seed_str.split(" ").filter_map(|c| c.parse::<usize>().ok()) {
        match prev {
            Some(start) => {
                seed_vec.append(&mut (start..start + u).collect());
                prev = None;
            }
            None => prev = Some(u),
        }
    }
    let mut seeds = seed_vec.into_iter();
    let mut new_seeds: Vec<usize> = seeds.clone().collect();

    for (nr, line) in lines.enumerate() {
        println!("Line : {}", nr);
        if line.contains("map:") {
            seeds = new_seeds.clone().into_iter();
            continue;
        }

        let mapping: Vec<usize> = line
            .split_whitespace()
            .filter_map(|n| n.parse::<usize>().ok())
            .collect();
        if mapping.len() != 3 {
            continue;
        }
        new_seeds = zip(seeds.clone(), new_seeds)
            .map(|(old, new)| transform(mapping[0], mapping[1], mapping[2], old, new))
            .collect();
    }

    println!("{}", new_seeds.iter().reduce(|a, b| a.min(b)).unwrap());
}
