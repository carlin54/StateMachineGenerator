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


def generate_state_machine(name, file, output_file):
    sm_file = open(file, "r")

    dict_states_to_events = dict()
    dict_states_to_superstates = dict()

    set_events = set()
    set_states = set()
    set_super_states = set()
    current_state = None
    for line in sm_file:
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
        "graph [ dpi = 700 ];\n" \
        "size=\"24,24\";" \

    for state in set_states:
        if state == "Unused":
            continue
        graph += "\nnode [shape = circle, label=\"" + state + "\"] \"" + state + "_State\";"

    for event in set_events:
        if event == "Unused":
            continue
        if event in set_states:
            continue
        graph += "\nnode [shape = box, label=\"" + event + "\"] \"" + event + "_Event\";"

    edges = set()
    for state in dict_states_to_superstates:
        if state == "Unused":
            continue

        super_states = dict_states_to_superstates[state]
        for super_state in super_states:
            edge = (state, super_state)
            if edge not in edges:
                edges.add(edge)
                graph += "\nedge [dir=\"both\"] \"" + state + "_State\" -> \"" + super_state + "_State\";"

    for start_state in dict_states_to_events:
        if start_state == "Unused":
            continue
        for event, next_state in dict_states_to_events[start_state]:
            edge = (start_state, event, next_state)
            if edge not in edges:
                edges.add(edge)
                if start_state == event == next_state:
                    graph += "\nedge [dir=\"forward\"] \"" + start_state + "_State\" -> \"" + start_state + "_State\";"
                    #graph += "\nedge [dir=\"forward\"] \"" + start_state + "_State\" -> \"" + event + "_Event\";"
                    #graph += "\nedge [dir=\"forward\"] \"" + event + "_Event\" -> \"" + next_state + "_State\";"
                elif start_state == next_state and start_state != event:
                    graph += "\nedge [dir=\"both\"] \"" + start_state + "_State\" -> \"" + event + "_Event\";"
                else:
                    graph += "\nedge [dir=\"forward\"] \"" + start_state + "_State\" -> \"" + event + "_Event\";"
                    graph += "\nedge [dir=\"forward\"] \"" + event + "_Event\" -> \"" + next_state + "_State\";"

    graph += "\nlabelloc=\"t\";"
    now = datetime.datetime.now()
    graph += "\nlabel=\"" + name + " State Machine Diagram - Generated on " + str(now)[0:19] + "\";"
    graph += "\n}"

    filename = output_file + name + ".gv"
    if verbose:
        print("Writing to: " + filename)
    s = Source(graph, filename=filename, format="png")
    s.render()


def main(argv):
    argv = sys.argv
    global verbose
    verbose = True
    input_file = None
    output_file = None
    try:
        opts, args = getopt.getopt(argv[1:],"i:o:",["input-file=","output-file="])
    except getopt.GetoptError:
        print('GenerateStateMachineDiagram.py -i <input file> -o <output file>')
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print('GenerateStateMachineDiagram.py -i <input file> -o <output file>')
            sys.exit()
        elif opt in ("-i", "--input-file"):
            input_file = arg
        elif opt in ("-o", "--output-file"):
            output_file = arg

    input_file = input_file if input_file[len(input_file)-1] == "/" else input_file + "/"
    output_file = output_file if output_file[len(output_file) - 1] == "/" else output_file + "/"
    print('Input directory is ', input_file)
    print('Output directory is ', output_file)
    os.path.isfile(

    for root, directories, files in os.walk(input_file, topdown=False):

        if "state.m" in files:
            # root = root.replace("\\" , "/")
            idx = root.rfind("/") + 1
            sm_name = root[idx:]
            sm_file = root + "/" + "state.m"
            if verbose:
                print("Generating graph for " + sm_name + " state using " + sm_file + " as source.")
            generate_state_machine(sm_name, sm_file, output_file)




if __name__ == "__main__":
    main(sys.argv[1:])
