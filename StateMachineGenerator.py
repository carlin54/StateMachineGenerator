#!/usr/bin/python

import re
import sys
import os
import shutil
from graphviz import Source

import os
os.environ["PATH"] += os.pathsep + r'C:\\Program Files\\Graphviz\\bin\\'

replace_val = " "



def is_comment(line):
  all = re.findall(r"!.*",line)
  return len(all) != 0


def is_instruction(line):
  all = re.findall(r"\+.*", line)
  return len(all) != 0


def is_state(line):
  all = re.findall(r"[A-Za-z]*:", line)
  return len(all) != 0


def is_event(line):
  all = re.findall(r"\(--\) .*", line)
  return len(all) != 0


def has_match(results):
  return len(results) != 0


def parse_state(line):
  idx = line.find(r':')
  assert (idx != -1)
  state = (line[:idx]).replace("-", replace_val).strip()
  super_states = (line[idx+1:])
  super_states = super_states.replace("<","")
  super_states = super_states.replace(" ", "")
  super_states = super_states.replace("-", replace_val).strip()
  super_states = super_states.split(">")
  super_states = super_states[:-1]
  return (state, super_states)


def parse_event(current_state, line):
  event = re.findall(r"\(--\) [A-Za-z\-]*", line)
  assert(has_match(event))
  event = event[0]
  event = (event[5:]).replace("-", replace_val).strip()

  next_state = re.findall(r"-> [A-Za-z\-]*", line)
  if has_match(next_state):
    next_state = next_state[0]
    next_state = (next_state[2:]).replace("-", replace_val).strip()
  else:
    next_state = current_state

  return current_state, event, next_state


def generate_state_machine(name, file, output_directory):
  sm_file = open(file, "r")


  dict_states_to_events = dict()
  dict_states_to_superstates = dict()


  set_events = set()
  set_states = set()
  current_state = None
  for line in sm_file:
    #print("line:" + line, end="")
    if is_comment(line):
      #print("comment:")
      continue

    if is_instruction(line):
      continue

    if is_state(line):
      current_state = parse_state(line)
      set_states.add(current_state[0])
      dict_states_to_superstates[current_state[0]] = current_state[1]
      dict_states_to_events[current_state[0]] = list()
      continue

    if is_instruction(line):
      #print("instruction: " + parse_state(line))
      continue

    if is_event(line):
      #print("event: " + str(parse_event(current_state, line)))
      event = parse_event(current_state[0], line)
      set_events.add(event[1])
      dict_states_to_superstates[current_state[0]] = current_state[1]
      dict_states_to_events[event[0]].append((event[1], event[2]))
      continue

  graph = \
    "digraph finite_state_machine {\n" \
    "rankdir=LR;\n" \
    "graph [ dpi = 700 ];\n" \
    "size=\"24,24\";" \

  for state in set_states:
    graph += "\nnode [shape = circle] \"" + state + "\";"

  for event in set_events:
    graph += "\nnode [shape = none] \"" + event + "\";"

  for current_state in dict_states_to_events:
    for event, next_state in dict_states_to_events[current_state]:
      graph += "\n\"" + current_state + "\" -> \"" + event + "\";"
      graph += "\n\"" + event + "\" -> \"" + next_state + "\";"

  for state in dict_states_to_superstates:
    for super_state in dict_states_to_superstates[state]:
      for event, next_super_state in dict_states_to_events[super_state]:
        graph += "\n\"" + super_state + "\" -> \"" + event + "\";"
        graph += "\n\"" + event + "\" -> \"" + next_super_state + "\";"


  """
  set_nodes = set()
  set_edges = set()
  for state in list_states:
    has_dependancy = len(state[1]) > 0
    if has_dependancy:
      graph += "\nnode [shape = doublecircle] \"" + state[0] + "\";"
    else:
      graph += "\nnode [shape = circle] \"" + state[0] + "\";"
    set_nodes.add(state[0])

  
  set_event_edges = set()
  for state in list_states:
    state_name = state[0]
    super_states = state[1]
    for super_state in super_states:
      intermediate_node = (super_state)
      graph += "\nnode [shape = circle, shape=none] \"" + intermediate_node + "\";"

      edge = (state_name, intermediate_node)
      graph += "\n\"" + state_name + "\" -> \"" + intermediate_node + "\";"

      edge = (intermediate_node, super_state)
      if edge not in set_event_edges:
        graph += "\n\"" + intermediate_node + "\" -> \"" + super_state + "\";"
        set_event_edges.add(edge)

  graph += "\n"
  for event in list_events:
      set_nodes.add(event[1])
      graph += "\nnode [shape = circle, shape=none] \"" + event[1] + "\";"

      if (event[0] == event[1] == event[2]):
        edge = (event[0], event[1])
        graph += "\n\"" + event[0] + "\" -> \"" + event[1] + "\";"
      else:
        edge = (event[0], event[1])
        graph += "\n\"" + event[0] + "\" -> \"" + event[1] + "\";"

        edge = (event[1], event[2])
        graph += "\n\"" + event[1] + "\" -> \"" + event[2] + "\";"

  #print(set_edges)
  set_edges = sorted(list(set_edges), key=lambda x: x[1].casefold())
  #print(set_edges)
  #for edge in set_edges:
  #  graph += "\n\"" + edge[0] + "\" -> \"" + edge[1] + "\";"
  """


  graph += "\n}"
  print(graph)


  filename = output_directory + name + ".gv"
  print("Writing to: " + filename)
  s = Source(graph, filename=filename, format="png")
  s.render()

def clear_folder(directory):
  for filename in os.listdir(directory):
    file_path = os.path.join(directory, filename)
    try:
      if os.path.isfile(file_path) or os.path.islink(file_path):
        os.unlink(file_path)
      elif os.path.isdir(file_path):
        shutil.rmtree(file_path)
    except Exception as e:
      print('Failed to delete %s. Reason: %s' % (file_path, e))


argv = sys.argv

source_directory = str(argv[1]) #"/home/carlconnell/code/ostk/src"
#source_directory =  #"/home/carlconnell/PycharmProjects/StateMachineGenerator"
output_directory = str(argv[2]) #"/home/carlconnell/PycharmProjects/StateMachineGenerator/output"

print("Parsing source directory: " + source_directory)
print("Outputting generated graphs into: " + output_directory)

for root, directories, files in os.walk(source_directory, topdown=False):

  if "state.m" in files:
    root = root.replace("\\" , "/")
    idx = root.rfind("/") + 1
    sm_name = root[idx:]
    sm_name = "LinuxInstall"
    sm_file = root + "/" + "state.m"
    print("Generating graph for " + sm_name + " state using " + sm_file + " as source.")
    generate_state_machine(sm_name, sm_file, output_directory)
