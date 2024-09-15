# Ponylang parrell perfect squares finder
This project uses the Pony programming language to find integers between 1 and N where the sum of squares of k consecutive integers is a perfect square. The solution is implemented using the actor model, with a boss actor distributing work to a pool of worker actors.

# Working
1) Worker Actors: Each worker actor computes the sum of squares for k consecutive integers in a given range, checks if the sum is a perfect square, and reports the results to the boss actor.
2) Boss Actor: The boss actor manages the worker actors, assigns tasks (ranges of integers), collects results, and prints the final output.

# How to Run
To run the program you need to pass following 3 parameters
1) N: The upper limit of the range of numbers to check.
2) k: The number of consecutive integers whose sum of squares needs to be checked.
3) num_workers: The number of worker actors that will process the ranges in parallel.

# Example command to run
1) Compile it first using ponyc
2) Once compiled use follwing command for a sample test case: .\Assignment1.exe 4000 24 10
This command will find perfect squares in the range from 1 to 4000, for 4 consecutive integers, using 10 workers.

# Result of running 1000000 4 
We do not get any result as there isn't any instances where the sum of square of 4 consecutive integers is also integer

# Running time of 1000000 4 with 2 workers
real    0m2.232s
user    0m0.016s
sys     0m0.056s

Ratio = 0.032

# Running time of 1000000 4 with 4 workers
real    0m0.107s
user    0m0.015s
sys     0m0.010s

Ratio = 0.23

# Running time of 1000000 4 with 10 workers
real    0m0.078s
user    0m0.001s
sys     0m0.019s

Ratio = 0.25

After testing with varying the number of workers, I found that distributing ranges equally across workers results in the best performance. For example, with N = 1,000,000 and num_workers = 10, each worker receives a range of 100,000 numbers to check. This result in the program to take the minimum time. I believe this balance minimizes idle time and maximizes parallel computation efficiency.


# Biggest problem that I able to solve
The biggest problem that I was able to solve was 100000000000 4 with 100 workers without waiting too long (around 40 seconds)







