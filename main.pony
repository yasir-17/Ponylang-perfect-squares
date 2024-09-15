use "collections"
use "time"

actor Worker
  let _id: USize
  let _boss: Boss

  new create(id: USize, boss: Boss) =>
    _id = id
    _boss = boss

  be find_perfect_squares(start: USize, end_val: USize, k: USize) =>
    for i in Range[USize](start, end_val + 1) do
      let sum = _sum_of_squares(i, k)
      if _is_perfect_square(sum) then
        _boss.report_result(_id, i, k, sum, i+k)
      end
    end
    _boss.worker_done()

  fun _sum_of_squares(start: USize, count: USize): USize =>
    var sum: USize = 0
    for i in Range[USize](start, start + count) do
      sum = sum + (i * i)
    end
    sum

  fun _is_perfect_square(n: USize): Bool =>
    let root = n.f64().sqrt().usize()
    (root * root) == n

actor Boss
  let _workers: Array[Worker] = Array[Worker]
  var _completed_workers: USize = 0
  let _num_workers: USize
  let _start_time: U64
  let _env: Env
  let _results: Array[(USize, USize)] = Array[(USize, USize)]

  new create(env: Env, num_workers: USize) =>
    _env = env
    _num_workers = num_workers
    _start_time = Time.nanos()
    for i in Range[USize](0, num_workers) do
      _workers.push(Worker(i, this))
    end

  be assign_work(n: USize, k: USize) =>
    let range_per_worker = n / _num_workers
    for i in Range[USize](0, _num_workers) do
      let start = (i * range_per_worker) + 1
      let end_val = if i == (_num_workers - 1) then n else (i + 1) * range_per_worker end
      try
        _workers(i)?.find_perfect_squares(start, end_val, k)
      else
        _env.out.print("Error: Worker " + i.string() + " not found")
      end
    end

  be report_result(worker_id: USize, start: USize, k: USize, sum: USize, end_idx: USize) =>
    _results.push((start, sum))
    _env.out.print("Worker " + worker_id.string() + " found: start = " + start.string() + " , end = " + end_idx.string() + ", sum = " + sum.string() + ", sqrt = " + sum.f64().sqrt().string())

  be worker_done() =>
    _completed_workers = _completed_workers + 1
    if _completed_workers == _num_workers then
      _print_final_results()
    end

  fun _print_final_results() =>
    _env.out.print("\nAll workers completed")
    """
    for (start, sum) in _results.values() do
      _env.out.print("  Starting at " + start.string() + ": sum = " + sum.string() + ", sqrt = " + sum.f64().sqrt().string())
      end
    """

actor Main
  new create(env: Env) =>
    try
      let n: USize = env.args(1)?.usize()?
      let k: USize = env.args(2)?.usize()?
      let num_workers: USize = env.args(3)?.usize()?

      let boss = Boss(env, num_workers)
      boss.assign_work(n, k)
    else
      env.out.print("Usage: program <N> <k> <num_workers>")
    end