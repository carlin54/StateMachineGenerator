# !/usr/bin/python
import getopt
import re
import sys
import os
import shutil
import datetime
from graphviz import Source

verbose = False
replace_val = " "


def is_parameter(line):
    return line.startswith('-')


def is_comment(line):
    all = re.findall(r"!.*", line)
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
    super_states = (line[idx + 1:])
    super_states = super_states.replace("<", "")
    super_states = super_states.replace(" ", "")
    super_states = super_states.replace("-", replace_val).strip()
    super_states = super_states.split(">")
    super_states = super_states[:-1]
    return (state, super_states)


def parse_event(current_state, line):
    event = re.findall(r"\(--\) [A-Za-z\-]*", line)
    assert (has_match(event))
    event = event[0]
    event = (event[5:]).replace("-", replace_val).strip()

    next_state = re.findall(r"-> [A-Za-z\-]*", line)
    if has_match(next_state):
        next_state = next_state[0]
        next_state = (next_state[2:]).replace("-", replace_val).strip()
    else:
        next_state = current_state

    return current_state, event, next_state


def generate_state_machine(name, input_file, output_dir, dpi):
    state_machine_file = open(input_file, "r")

    dict_states_to_events = dict()
    dict_states_to_superstates = dict()

    set_events = set()
    set_states = set()
    set_super_states = set()
    current_state = None
    for line in state_machine_file:
        
        if is_parameter(line):
            continue

        if is_comment(line):
            continue

        if is_instruction(line):
            continue

        if is_state(line):
            current_state = parse_state(line)

            for super_state in current_state[1]:
                set_super_states.add(super_state)

            set_states.add(current_state[0])
            dict_states_to_superstates[current_state[0]] = current_state[1]
            dict_states_to_events[current_state[0]] = list()
            continue

        if is_instruction(line):
            continue

        if is_event(line):
            event = parse_event(current_state[0], line)
            set_events.add(event[1])
            dict_states_to_superstates[current_state[0]] = current_state[1]
            dict_states_to_events[event[0]].append((event[1], event[2]))
            continue

    graph = \
        "digraph finite_state_machine {\n" \
        "rankdir=LR;\n" \
        "graph [ dpi = " + dpi + " ];\n" \
        "size=\"24,24\";" \

    for state in set_states:
        graph += "\nnode [shape = circle, label=\"" + state + "\"] \"" + state + "_State\";"

    for event in set_events:
        if event in set_states:
            continue
        graph += "\nnode [shape = box, label=\"" + event + "\"] \"" + event + "_Event\";"

    edges = set()
    for state in dict_states_to_superstates:
        super_states = dict_states_to_superstates[state]
        for super_state in super_states:
            edge = (state, super_state)
            if edge not in edges:
                edges.add(edge)
                graph += "\nedge [dir=\"both\"] \"" + state + "_State\" -> \"" + super_state + "_State\";"

    for start_state in dict_states_to_events:
        for event, next_state in dict_states_to_events[start_state]:
            edge = (start_state, event, next_state)
            if edge not in edges:
                edges.add(edge)
                if start_state == event == next_state:
                    graph += "\nedge [dir=\"forward\"] \"" + start_state + "_State\" -> \"" + start_state + "_State\";"
                elif start_state == next_state and start_state != event:
                    graph += "\nedge [dir=\"both\"] \"" + start_state + "_State\" -> \"" + event + "_Event\";"
                else:
                    graph += "\nedge [dir=\"forward\"] \"" + start_state + "_State\" -> \"" + event + "_Event\";"
                    graph += "\nedge [dir=\"forward\"] \"" + event + "_Event\" -> \"" + next_state + "_State\";"

    graph += "\nlabelloc=\"t\";"
    now = datetime.datetime.now()
    graph += "\nlabel=\"" + name + " State Machine Diagram - Generated on " + str(now)[0:19] + "\";"
    graph += "\n}"

    s = Source(graph)
    s.render(outfile=output_dir + name + ".png", overwrite_source=True,format='png')

def usage():
    print("-h, --help")
    print("\tdisplays this text, then exits.")
    print("-i, --input-file")
    print("\tthe input libero state machine file to generate. A diagram and a dot file will be generated from the input file.")
    print("-o, --output-file")
    print("\tthe directory to output the dot and png files.")
    print("-n, --name")
    print("\tsets the name for the output dot and png files.")
    print("-d, --dpi")
    print("\tsets the dpi parameter for the generated image.")

def main():
    argv = sys.argv
    global verbose
   
    verbose = True
    input_file = None
    output_dir = None
    name = None
    dpi = None

    try:
        opts, args = getopt.getopt(argv[1:],"i:o:n:d:",["input-file=","output-dir=","name=","dpi="])
    except getopt.GetoptError:
        usage()
        sys.exit(1)
    for opt, arg in opts:
        if opt == '-h':
            usage()
            sys.exit()
        elif opt in ("-i", "--input-file"):
            input_file = arg
        elif opt in ("-o", "--output-dir"):
            output_dir = arg
        elif opt in ("-n", "--name"):
            name = arg
        elif opt in ("-d", "--dpi"):
            dpi = arg
        else:
            usage()
            sys.exit(2)

    if input_file is None:
        print("Error: input file is mandatory.")
        sys.exit(3)
    
    if os.path.isdir(input_file):
        print("Error: input file is directory and not a file.")
        sys.exit()

    if not os.path.isfile(input_file):
        print("Error: input file is not a file.")
        sys.exit(4)

    if output_dir is None:
        output_dir = os.path.dirname(input_file)
        output_dir = os.path.splitext(output_dir)[0]
    
    if not output_dir.endswith("/"):
        output_dir += "/"

    if not os.path.isdir(output_dir):
        print("Error: output directory is not a directory.")
        sys.exit(5)

    if name is None:
        name = os.path.basename(input_file)
        name = os.path.splitext(name)[0]
    
    if dpi is None:
        dpi = "500"
    
    if not dpi.isnumeric():
        print("Error: dpi is not numeric.")
        sys.exit(6)
    
    if int(dpi) < 1:
        print("Error: dpi is less than 1.")
        sys.exit(7)
    
    generate_state_machine(name, input_file, output_dir, dpi)
    sys.exit(0)


if __name__ == "__main__":
    main()
