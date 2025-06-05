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

   Phase Name                   |     Description                                                               |          Execution approach           |               Phase Type    
                                       
   pre_reset                          Used to add any activity or functionality before reset as                             Parallel                                    Task
                                      power-up signal goes active   
                                       
   reset                              Used to generate a reset and put an interface into its                                Parallel                                    Task
                                      default state.
                        
   post_reset                         Used to add any activity that is required immediately                                 Parallel                                    Task
                                      after reset

   pre_configure                      After the reset is completed, this phase is used to prepare DUT for                   Parallel                                    Task
                                      configuration programming. 
                                      Ex: It may be used as a last chance to update information before 
                                      it is passed to the DUT.

   configure                           Used to program the DUT and any memories in the testbench to keep                   Parallel                                    Task
                                       it ready for the start of the test case.

   post_configure                      Used to wait for the response after configuring DUT or wait for a                   Parallel                                    Task
                                       certain DUT state so that the main test stimulus can be started.

   pre_main                            Used to ensure that all required components are ready to generate stimulus.         Parallel                                    Task

   main                                Used to apply generated stimulus to the DUT.                                        Parallel                                    Task
                                       Most of the time, stimuli are handled using sequences. 
                                       This phase completed either all stimuli are exhausted or a timeout occurred.
   
   post_main                           Used to take care of any finalization of the main phase                             Parallel                                    Task

   pre_shutdown                        This phase is a buffer for any DUT stimuli that have to take care before            Parallel                                    Task
                                       the shutdown phase.

   shutdown                            Used to ensure that the effects of stimuli are driven to DUT during main_phase      Parallel                                    Task
                                       and that any resultant data has drained away. 
                                       This phase may also be used to execute any time-consuming sequences 
                                       that read status registers.  

   post_shutdown                       Used to perform any final activity before existing time-consuming simulation        Parallel                                    Task
                                       phases.  

4. Clean up phases: The clean-up phases are used to collect information from functional coverage monitors and scoreboards to see whether the coverage goal has been reached or the test case has passed. 
                    The cleanup phases will start once the run phases are completed. 
                    They are implemented as functions and work from the bottom to the top of the component hierarchy. 
                    The extract, check and report phase may be used by analysis components.  

 Phase Name                   |     Description                                                  |          Execution approach           |               Phase Type    

 extract                            Used to retrieve and process the information from functional             Bottom to top                                Function
                                    coverage monitors and scoreboards. 
                                    This phase may also calculate any statistical information 
                                    that will be used by report_phase.

 check                               Checks DUT behavior and identity for any error that occurred            Bottom to top                                Function
                                     during the execution of the testbench.

 report                              Used to display simulation results.                                     Bottom to top                                Function
                                     It can also write results to the file.                                   

 final                               Used to complete any outstanding actions that are yet to be             Bottom to top                                Function
                                     completed in the testbench.  
     
