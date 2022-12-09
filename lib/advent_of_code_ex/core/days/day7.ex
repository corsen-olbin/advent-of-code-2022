defmodule AdventOfCodeEx.Core.Days.Day7 do
  def part_1(input) do
    input
    # split on $ separates out all the commands w/ their responses
    |> String.split("$ ", trim: true)
    |> Enum.map(&interpret_instruction/1)
    |> build_directory
    |> find_all_directories_that_meet_cond(&(&1.size < 100_000))
    |> Enum.reduce(0, fn {_dir_name, size}, acc -> size + acc end)
  end

  def part_2(input) do
    input
    # split on $ separates out all the commands w/ their responses
    |> String.split("$ ", trim: true)
    |> Enum.map(&interpret_instruction/1)
    |> build_directory
    # find all directories that meet condition 70_000_000 - (current_total_space - x)  > 30_000_000
    |> find_all_directories_that_would_free_up_enough_space
    |> Enum.reduce(70_000_000, fn {_dir_name, size}, acc -> if size < acc, do: size, else: acc end)
  end

  def interpret_instruction(command) do
    [input | response_lines] = command |> String.split("\r\n", trim: true)

    case Regex.named_captures(
           ~r/(?<command>[a-zA-Z0-9\/]+) *(?<folder_name>[a-zA-Z0-9\/.]*)/,
           input
         ) do
      %{"command" => "cd", "folder_name" => folder_name} -> {:cd, folder_name}
      %{"command" => "ls"} -> {:ls, Enum.map(response_lines, &interpret_response_line/1)}
      _ -> raise "you forgot a command"
    end
  end

  def interpret_response_line(line) do
    case Regex.named_captures(
           ~r/(dir (?<dir_name>[a-zA-Z0-9\/]+))? *((?<size>[0-9\/]+) (?<file_name>[a-zA-Z0-9.]+))?/,
           line
         ) do
      %{"dir_name" => dir_name, "size" => "", "file_name" => ""} -> {:dir, dir_name}
      %{"dir_name" => "", "size" => size, "file_name" => file_name} -> {:file, size, file_name}
      _ -> raise "weird ls response line"
    end
  end

  def build_directory(command_list) do
    {dir, _} = build_directory_rec(%{}, command_list)
    dir
  end

  def build_directory_rec(acc, []), do: {update_dir_size(acc), []}
  def build_directory_rec(acc, [{:cd, ".."} | commands]), do: {update_dir_size(acc), commands}

  def build_directory_rec(acc, [{:cd, dir_name} | commands]) do
    {new_inner_directory, remaining_commands} =
      build_directory_rec(Map.get(acc, {:dir, dir_name}, %{}), commands)

    new_acc = Map.put(acc, {:dir, dir_name}, new_inner_directory)
    build_directory_rec(new_acc, remaining_commands)
  end

  def build_directory_rec(acc, [{:ls, ls_response_list} | commands]) do
    new_acc = Enum.reduce(ls_response_list, acc, fn x, a -> update_directory_lazy(a, x) end)
    build_directory_rec(new_acc, commands)
  end

  def update_directory_lazy(directory, ls_response) do
    case ls_response do
      {:file, size, file_name} ->
        Map.put_new_lazy(directory, {:file, file_name}, fn -> %{size: String.to_integer(size)} end)

      {:dir, dir_name} ->
        Map.put_new_lazy(directory, {:dir, dir_name}, fn -> %{} end)
    end
  end

  def update_dir_size(directory) do
    new_size = Enum.reduce(directory, 0, fn {_k, v}, acc -> acc + Map.get(v, :size, 0) end)
    Map.update(directory, :size, new_size, fn old_size -> new_size - old_size end)
  end

  def find_all_directories_that_meet_cond(directory_map, cond?) do
    find_all_directories_that_meet_cond_rec(
      [],
      Enum.filter(directory_map, fn {k, _v} -> is_directory?(k) end),
      cond?
    )
  end

  def find_all_directories_that_meet_cond_rec(acc, [], _cond?), do: acc

  def find_all_directories_that_meet_cond_rec(acc, [{{:dir, dir_name}, dir} | stack], cond?) do
    new_stack = Enum.filter(dir, fn {k, _v} -> is_directory?(k) end) ++ stack

    cond do
      cond?.(dir) ->
        find_all_directories_that_meet_cond_rec([{dir_name, dir.size} | acc], new_stack, cond?)

      true ->
        find_all_directories_that_meet_cond_rec(acc, new_stack, cond?)
    end
  end

  def is_directory?(key) do
    case key do
      {:dir, _} -> true
      _ -> false
    end
  end

  # Part 2
  def find_all_directories_that_would_free_up_enough_space(directory) do
    # calc minimum directory size to free up space
    # 70_000_000 - (current_total_space - x)  > 30_000_000
    # 40_000_000 > current_total_space - x
    # -40_000_000 + current_total_space < x
    mimimum_space_needed = directory.size - 40_000_000
    find_all_directories_that_meet_cond(directory, &(&1.size > mimimum_space_needed))
  end
end
