use std::fs;

fn transform(dst: u32, src: u32, range: u32, old_seed: u32) -> Option<u32> {
    return if old_seed < src || src + range <= old_seed {
        None
    } else {
        Some(old_seed - src + dst)
    };
}

fn main() {
    let input = fs::read_to_string("input").unwrap();
    let mut lines = input.lines();

    let seed_str = lines.next().unwrap();
    let mut seeds = vec![];
    let mut prev = None::<u32>;
    for u in seed_str.split(" ").filter_map(|c| c.parse::<u32>().ok()) {
        match prev {
            Some(start) => {
                seeds.append(&mut (start..start + u).map(|u| (u, u)).collect());
                prev = None;
            }
            None => prev = Some(u),
        }
    }

    for (nr, line) in lines.enumerate() {
        println!("Line : {}", nr);
        if line.contains("map:") {
            seeds = seeds.into_iter().map(|(_, new)| (new, new)).collect();
            continue;
        }

        let mapping: Vec<u32> = line
            .split_whitespace()
            .filter_map(|n| n.parse::<u32>().ok())
            .collect();
        if mapping.len() != 3 {
            continue;
        }
        seeds = seeds
            .into_iter()
            .map(|(old, new)| match transform(mapping[0], mapping[1], mapping[2], old) {
                Some(new) => (old, new),
                None => (old, new),
            })
            .collect();
    }

    println!("{}", seeds.iter().map(|(_, u)| u).reduce(|a, b| a.min(b)).unwrap());
}
