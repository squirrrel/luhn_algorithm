## Special Notes
- The intention behind this code snippet was to learn the Elixir language basic features.

- The server helps to define wether an input number is valid according to the Luhn algorithm. Otherwise it can make it valid by generating a so called check digit and append it to the initial number for you. It is used to validate a variety of identification numbers. See [Luhn Algorithm][1]

- I initially implemented the algo with Ruby through a plain class inheritance approach (added `luhn_algo.rb` to this commit). You will have to create a bunch of objects in order to perform either of the tasks against them. No server involved, so all the calls are synchronous.

- With my asynchronous elixir implemenation, creating `mix new luhn_algo_server` project would probaly make more sense, though I decided to stick to a single .ex file in order to keep my commit smaller and to avoid all those extra things that come with the mix-stack. 

### Server API usage instructions
1. You have to start a server first:
```
server_pid = LuhnAlgoServer.start()
```
_It will return  the server pid object_

2. To check whether a _card?_ number is valid according to the Luhn algorithm:
```
send(server_pid, {:is_full_luhn_valid, 1111111111111111})
```
_It can return a tuple: either {:ok, true, value} or {:error, false, matchvalue}. (In this case it will {:error, false, %MatchError{term: 7}})_

3. To append a check digit:
```
send(server_pid, {:append_check_digit, 111111111111111})
```
_It will return same number suffixed with the check digit: 1111111111111117_

### Environment setup
After pulling the project from the github, in order to make use of the server, first perform the following steps:

#### I. With compilation
1. go to the root directory and run:
```
elixirc LuhnAlgoServer.ex
```
_This will compile the containing module into Elixir.LuhnAlgoServer.beam code file and place it inside the current directory._

2. In the same directory run:
```
iex
```
_This will load interactive elixir mode. Since we already compiled the file, `iex` will be smart enough to go and find the beam file and call the module when needed. So it behaves as if it were already in the module's scope._

Alternatively:
1. go to the root directory and run:
```
iex
```

2. when in interactive mode, run:
```
iex> c("LuhnAlgoServer.ex")
```
_In both cases, two steps will be performed: file execution and its further compilation._

#### Why it is better to compile
- load modules into current scope with ease;
- inspecting modules documentations and methods specs:
```
iex> h LuhnAlgoServer
iex> s LuhnAlgoServer
```
- (static) check of program adequacy with the specs and dialyzer;
- check whether the program interface corresponds to that of the included behaviour.

#### II. Without compilation - Running as a script
1. Run:
```
iex LuhnAlgoServer.ex(s)
```

2. Run:
```
iex
```
Then copy the LuhnAlgoServer.ex(s) file contents and past it directly to the interactive shell

3. Will work if you previously make server calls directly from the file to make sure the output:
```
elixir LuhnAlgoServer.ex(s)
```

[1]: http://www.wikiwand.com/en/Luhn_algorithm



