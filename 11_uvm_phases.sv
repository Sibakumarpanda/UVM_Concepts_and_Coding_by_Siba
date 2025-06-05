UVM Phases Concept:

Why are phases introduced for UVM based System Verilog testbench but not for Verilog-based testbench ???
- All components are static in Verilog-based testbench whereas System Verilog introduced OOP (Object Oriented Programming) feature in the testbench,concept of class which is dynamic in nature. 
- In Verilog, as modules are static, users don’t have to care about their creation as they would have already created at the beginning of the simulation. 
- But , In the case of UVM based System Verilog testbench, class objects can be created at any time during the simulation based on the requirement. 
- Hence, it is required to have proper synchronization to avoid objects/components being called before they are created, hence its important to say that UVM phasing mechanism serves the purpose of synchronization.
  
The phases are an important concept in uvm that applies to all TB components.
- Each testbench component is derived from uvm_component that has predefined phases. They are represented as callback methods. Hence, the user may implement these callbacks.
- Each component can not move to the next phase unless the current phase execution is completed for all the components. This provides proper synchronization between all the components.
- UVM phases are executed in a certain order and all are virtual methods.
- Few phases that consume simulation time for execution are implemented as tasks and other phases that do not consume any simulation time are implemented as functions.
- Main categories in UVM phases.
  1. Build phases: Used to configure or construct the testbench. (They are build_phase,connect_phase, end_of_elaboration_phase)
  2. Run-time phases: Time-consuming testbench activity like running the test case. (They are start_of_simulation_phase,run_phase and sub phases of run_phase like reset , configure , main, shutdown)
  3. Clean up phases: Collect and report the results of the simulation. (extract_phase, check_phase, report_phase, final_phase)

How does UVM phase execution start?
    
The run_test() method is required to call from the static part of the testbench. 
This will trigger up the UVM testbench. 
It is usually called in the initial block from the top-level testbench module. 
The run_test() method call to construct the UVM environment root component and then initiates the UVM phasing mechanism.

1. Build phases: To construct a testbench, it is necessary to build component objects first and then are connected to form a hierarchy, The build phase category consists
   a. build_phase
   b. connect_phase
   c. end_of_elaboration_phase  

 Phase Name       |        Description                                    |          Execution approach           |               Phase Type     
 build_phase               Build or create testbench component                        Top to down                                  Function
  
 connect_phase             Connect different testbench component                      Bottom to top                                Function
                           using the TLM port mechanism     
  
 end_of_elaboration_phase  Before simulation starts, this phase is used to make       Bottom to top                                Function
                           any final adjustment to the structure, configuration, 
                           or connectivity of the testbench. 
                           It also displays UVM topology. 

2. start_of_simulation_phase: 
  
   Phase Name                   |           Description                                             |          Execution approach           |               Phase Type     
   start_of_simulation_phase                Used to display testbench topology or configuration                Bottom to top                                 Function

3. Run-time phases : Once testbench components are created and connected in the testbench, it follows run phases where actual simulation time consumes. 
                     After completing, start_of_simulation phase, there are two paths for run-time phases. The run_phase and pre_reset phase both start at the same time.

  a. run_phase
 
                       
  Phase Name                   |     Description                                                |          Execution approach           |               Phase Type     
  run_phase                          Used for the stimulus generation, checking activities                 Parallel                                     Task
                                     of the testbench, and consumes simulation time cycles. 
                                     The run_phase for all components are executed in parallel.                                              

  b. Other Phases that run parallel to run_phases (pre_reset, reset, post_reset, pre_configure, configure, post_configure, pre_main, main, post_main, pre_shutdown,shutdown, post_shutdown phases)   


                       
