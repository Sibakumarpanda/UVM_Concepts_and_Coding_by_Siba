///////////////////////////////////////(..................summary....................)/////////////////////////////////////////

The following points can be noted and observed in the above logs

-UVM_SEQ_ARB_FIFO and UVM_SEQ_ARB_RANDOM arbitration modes do not modify sequence execution even if priorities are specified.
-UVM_SEQ_ARB_STRICT_FIFO without any priority mentioned and UVM_SEQ_ARB_FIFO modes provide the same outcome.
-UVM_SEQ_ARB_STRICT_FIFO mode outcome changes based on priorities.
-UVM_SEQ_ARB_RANDOM and UVM_SEQ_ARB_STRICT_RANDOM provide the same outcome if no priorities are mentioned.

1. SEQ_ARB_FIFO 

----> SEQ_ARB_FIFO with and without priority outcomes will be same.
----> It will executed in order. Mean while if we provide priority.

2. SEQ_ARB_WEIGHTED

----> SEQ_ARB_WEIGHTED with and without priority outcomes will be different.

3. SEQ_ARB_RANDOM

----> SEQ_ARB_RANDOM with and without priority outcomes will be same.
----> It will not consider the priority order.

4. SEQ_ARB_STRICT_FIFO

----> SEQ_ARB_STRICT_FIFO with and without priority outcomes will be different.
----> SEQ_ARB_STRICT_FIFO and SEQ_ARB_FIFO without priority both outcomes will be same.

5. SEQ_ARB_STRICT_RANDOM

----> SEQ_ARB_STRICT_RANDOM with and without priority outcomes will be different.
----> SEQ_ARB_STRICT_RANDOM and SEQ_ARB_RANDOM without priority both outcomes will be same.
