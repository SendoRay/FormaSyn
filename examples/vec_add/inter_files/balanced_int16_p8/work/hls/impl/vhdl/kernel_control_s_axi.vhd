-- ==============================================================
-- Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.1 (64-bit)
-- Tool Version Limit: 2025.05
-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
-- 
-- ==============================================================
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity kernel_control_s_axi is
generic (
    C_S_AXI_ADDR_WIDTH    : INTEGER := 9;
    C_S_AXI_DATA_WIDTH    : INTEGER := 32);
port (
    ACLK                  :in   STD_LOGIC;
    ARESET                :in   STD_LOGIC;
    ACLK_EN               :in   STD_LOGIC;
    AWADDR                :in   STD_LOGIC_VECTOR(C_S_AXI_ADDR_WIDTH-1 downto 0);
    AWVALID               :in   STD_LOGIC;
    AWREADY               :out  STD_LOGIC;
    WDATA                 :in   STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH-1 downto 0);
    WSTRB                 :in   STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH/8-1 downto 0);
    WVALID                :in   STD_LOGIC;
    WREADY                :out  STD_LOGIC;
    BRESP                 :out  STD_LOGIC_VECTOR(1 downto 0);
    BVALID                :out  STD_LOGIC;
    BREADY                :in   STD_LOGIC;
    ARADDR                :in   STD_LOGIC_VECTOR(C_S_AXI_ADDR_WIDTH-1 downto 0);
    ARVALID               :in   STD_LOGIC;
    ARREADY               :out  STD_LOGIC;
    RDATA                 :out  STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH-1 downto 0);
    RRESP                 :out  STD_LOGIC_VECTOR(1 downto 0);
    RVALID                :out  STD_LOGIC;
    RREADY                :in   STD_LOGIC;
    interrupt             :out  STD_LOGIC;
    a_0                   :out  STD_LOGIC_VECTOR(63 downto 0);
    a_1                   :out  STD_LOGIC_VECTOR(63 downto 0);
    a_2                   :out  STD_LOGIC_VECTOR(63 downto 0);
    a_3                   :out  STD_LOGIC_VECTOR(63 downto 0);
    a_4                   :out  STD_LOGIC_VECTOR(63 downto 0);
    a_5                   :out  STD_LOGIC_VECTOR(63 downto 0);
    a_6                   :out  STD_LOGIC_VECTOR(63 downto 0);
    a_7                   :out  STD_LOGIC_VECTOR(63 downto 0);
    b_0                   :out  STD_LOGIC_VECTOR(63 downto 0);
    b_1                   :out  STD_LOGIC_VECTOR(63 downto 0);
    b_2                   :out  STD_LOGIC_VECTOR(63 downto 0);
    b_3                   :out  STD_LOGIC_VECTOR(63 downto 0);
    b_4                   :out  STD_LOGIC_VECTOR(63 downto 0);
    b_5                   :out  STD_LOGIC_VECTOR(63 downto 0);
    b_6                   :out  STD_LOGIC_VECTOR(63 downto 0);
    b_7                   :out  STD_LOGIC_VECTOR(63 downto 0);
    c_0                   :out  STD_LOGIC_VECTOR(63 downto 0);
    c_1                   :out  STD_LOGIC_VECTOR(63 downto 0);
    c_2                   :out  STD_LOGIC_VECTOR(63 downto 0);
    c_3                   :out  STD_LOGIC_VECTOR(63 downto 0);
    c_4                   :out  STD_LOGIC_VECTOR(63 downto 0);
    c_5                   :out  STD_LOGIC_VECTOR(63 downto 0);
    c_6                   :out  STD_LOGIC_VECTOR(63 downto 0);
    c_7                   :out  STD_LOGIC_VECTOR(63 downto 0);
    ap_start              :out  STD_LOGIC;
    ap_done               :in   STD_LOGIC;
    ap_ready              :in   STD_LOGIC;
    ap_continue           :out  STD_LOGIC;
    ap_idle               :in   STD_LOGIC
);
end entity kernel_control_s_axi;

-- ------------------------Address Info-------------------
-- Protocol Used: ap_ctrl_chain
--
-- 0x000 : Control signals
--         bit 0  - ap_start (Read/Write/COH)
--         bit 1  - ap_done (Read)
--         bit 2  - ap_idle (Read)
--         bit 3  - ap_ready (Read/COR)
--         bit 4  - ap_continue (Read/Write/SC)
--         bit 7  - auto_restart (Read/Write)
--         bit 9  - interrupt (Read)
--         others - reserved
-- 0x004 : Global Interrupt Enable Register
--         bit 0  - Global Interrupt Enable (Read/Write)
--         others - reserved
-- 0x008 : IP Interrupt Enable Register (Read/Write)
--         bit 0 - enable ap_done interrupt (Read/Write)
--         bit 1 - enable ap_ready interrupt (Read/Write)
--         others - reserved
-- 0x00c : IP Interrupt Status Register (Read/TOW)
--         bit 0 - ap_done (Read/TOW)
--         bit 1 - ap_ready (Read/TOW)
--         others - reserved
-- 0x010 : Data signal of a_0
--         bit 31~0 - a_0[31:0] (Read/Write)
-- 0x014 : Data signal of a_0
--         bit 31~0 - a_0[63:32] (Read/Write)
-- 0x018 : reserved
-- 0x01c : Data signal of a_1
--         bit 31~0 - a_1[31:0] (Read/Write)
-- 0x020 : Data signal of a_1
--         bit 31~0 - a_1[63:32] (Read/Write)
-- 0x024 : reserved
-- 0x028 : Data signal of a_2
--         bit 31~0 - a_2[31:0] (Read/Write)
-- 0x02c : Data signal of a_2
--         bit 31~0 - a_2[63:32] (Read/Write)
-- 0x030 : reserved
-- 0x034 : Data signal of a_3
--         bit 31~0 - a_3[31:0] (Read/Write)
-- 0x038 : Data signal of a_3
--         bit 31~0 - a_3[63:32] (Read/Write)
-- 0x03c : reserved
-- 0x040 : Data signal of a_4
--         bit 31~0 - a_4[31:0] (Read/Write)
-- 0x044 : Data signal of a_4
--         bit 31~0 - a_4[63:32] (Read/Write)
-- 0x048 : reserved
-- 0x04c : Data signal of a_5
--         bit 31~0 - a_5[31:0] (Read/Write)
-- 0x050 : Data signal of a_5
--         bit 31~0 - a_5[63:32] (Read/Write)
-- 0x054 : reserved
-- 0x058 : Data signal of a_6
--         bit 31~0 - a_6[31:0] (Read/Write)
-- 0x05c : Data signal of a_6
--         bit 31~0 - a_6[63:32] (Read/Write)
-- 0x060 : reserved
-- 0x064 : Data signal of a_7
--         bit 31~0 - a_7[31:0] (Read/Write)
-- 0x068 : Data signal of a_7
--         bit 31~0 - a_7[63:32] (Read/Write)
-- 0x06c : reserved
-- 0x070 : Data signal of b_0
--         bit 31~0 - b_0[31:0] (Read/Write)
-- 0x074 : Data signal of b_0
--         bit 31~0 - b_0[63:32] (Read/Write)
-- 0x078 : reserved
-- 0x07c : Data signal of b_1
--         bit 31~0 - b_1[31:0] (Read/Write)
-- 0x080 : Data signal of b_1
--         bit 31~0 - b_1[63:32] (Read/Write)
-- 0x084 : reserved
-- 0x088 : Data signal of b_2
--         bit 31~0 - b_2[31:0] (Read/Write)
-- 0x08c : Data signal of b_2
--         bit 31~0 - b_2[63:32] (Read/Write)
-- 0x090 : reserved
-- 0x094 : Data signal of b_3
--         bit 31~0 - b_3[31:0] (Read/Write)
-- 0x098 : Data signal of b_3
--         bit 31~0 - b_3[63:32] (Read/Write)
-- 0x09c : reserved
-- 0x0a0 : Data signal of b_4
--         bit 31~0 - b_4[31:0] (Read/Write)
-- 0x0a4 : Data signal of b_4
--         bit 31~0 - b_4[63:32] (Read/Write)
-- 0x0a8 : reserved
-- 0x0ac : Data signal of b_5
--         bit 31~0 - b_5[31:0] (Read/Write)
-- 0x0b0 : Data signal of b_5
--         bit 31~0 - b_5[63:32] (Read/Write)
-- 0x0b4 : reserved
-- 0x0b8 : Data signal of b_6
--         bit 31~0 - b_6[31:0] (Read/Write)
-- 0x0bc : Data signal of b_6
--         bit 31~0 - b_6[63:32] (Read/Write)
-- 0x0c0 : reserved
-- 0x0c4 : Data signal of b_7
--         bit 31~0 - b_7[31:0] (Read/Write)
-- 0x0c8 : Data signal of b_7
--         bit 31~0 - b_7[63:32] (Read/Write)
-- 0x0cc : reserved
-- 0x0d0 : Data signal of c_0
--         bit 31~0 - c_0[31:0] (Read/Write)
-- 0x0d4 : Data signal of c_0
--         bit 31~0 - c_0[63:32] (Read/Write)
-- 0x0d8 : reserved
-- 0x0dc : Data signal of c_1
--         bit 31~0 - c_1[31:0] (Read/Write)
-- 0x0e0 : Data signal of c_1
--         bit 31~0 - c_1[63:32] (Read/Write)
-- 0x0e4 : reserved
-- 0x0e8 : Data signal of c_2
--         bit 31~0 - c_2[31:0] (Read/Write)
-- 0x0ec : Data signal of c_2
--         bit 31~0 - c_2[63:32] (Read/Write)
-- 0x0f0 : reserved
-- 0x0f4 : Data signal of c_3
--         bit 31~0 - c_3[31:0] (Read/Write)
-- 0x0f8 : Data signal of c_3
--         bit 31~0 - c_3[63:32] (Read/Write)
-- 0x0fc : reserved
-- 0x100 : Data signal of c_4
--         bit 31~0 - c_4[31:0] (Read/Write)
-- 0x104 : Data signal of c_4
--         bit 31~0 - c_4[63:32] (Read/Write)
-- 0x108 : reserved
-- 0x10c : Data signal of c_5
--         bit 31~0 - c_5[31:0] (Read/Write)
-- 0x110 : Data signal of c_5
--         bit 31~0 - c_5[63:32] (Read/Write)
-- 0x114 : reserved
-- 0x118 : Data signal of c_6
--         bit 31~0 - c_6[31:0] (Read/Write)
-- 0x11c : Data signal of c_6
--         bit 31~0 - c_6[63:32] (Read/Write)
-- 0x120 : reserved
-- 0x124 : Data signal of c_7
--         bit 31~0 - c_7[31:0] (Read/Write)
-- 0x128 : Data signal of c_7
--         bit 31~0 - c_7[63:32] (Read/Write)
-- 0x12c : reserved
-- (SC = Self Clear, COR = Clear on Read, TOW = Toggle on Write, COH = Clear on Handshake)

architecture behave of kernel_control_s_axi is
    type states is (wridle, wrdata, wrresp, wrreset, rdidle, rddata, rdreset);  -- read and write fsm states
    signal wstate  : states := wrreset;
    signal rstate  : states := rdreset;
    signal wnext, rnext: states;
    constant ADDR_AP_CTRL    : INTEGER := 16#000#;
    constant ADDR_GIE        : INTEGER := 16#004#;
    constant ADDR_IER        : INTEGER := 16#008#;
    constant ADDR_ISR        : INTEGER := 16#00c#;
    constant ADDR_A_0_DATA_0 : INTEGER := 16#010#;
    constant ADDR_A_0_DATA_1 : INTEGER := 16#014#;
    constant ADDR_A_0_CTRL   : INTEGER := 16#018#;
    constant ADDR_A_1_DATA_0 : INTEGER := 16#01c#;
    constant ADDR_A_1_DATA_1 : INTEGER := 16#020#;
    constant ADDR_A_1_CTRL   : INTEGER := 16#024#;
    constant ADDR_A_2_DATA_0 : INTEGER := 16#028#;
    constant ADDR_A_2_DATA_1 : INTEGER := 16#02c#;
    constant ADDR_A_2_CTRL   : INTEGER := 16#030#;
    constant ADDR_A_3_DATA_0 : INTEGER := 16#034#;
    constant ADDR_A_3_DATA_1 : INTEGER := 16#038#;
    constant ADDR_A_3_CTRL   : INTEGER := 16#03c#;
    constant ADDR_A_4_DATA_0 : INTEGER := 16#040#;
    constant ADDR_A_4_DATA_1 : INTEGER := 16#044#;
    constant ADDR_A_4_CTRL   : INTEGER := 16#048#;
    constant ADDR_A_5_DATA_0 : INTEGER := 16#04c#;
    constant ADDR_A_5_DATA_1 : INTEGER := 16#050#;
    constant ADDR_A_5_CTRL   : INTEGER := 16#054#;
    constant ADDR_A_6_DATA_0 : INTEGER := 16#058#;
    constant ADDR_A_6_DATA_1 : INTEGER := 16#05c#;
    constant ADDR_A_6_CTRL   : INTEGER := 16#060#;
    constant ADDR_A_7_DATA_0 : INTEGER := 16#064#;
    constant ADDR_A_7_DATA_1 : INTEGER := 16#068#;
    constant ADDR_A_7_CTRL   : INTEGER := 16#06c#;
    constant ADDR_B_0_DATA_0 : INTEGER := 16#070#;
    constant ADDR_B_0_DATA_1 : INTEGER := 16#074#;
    constant ADDR_B_0_CTRL   : INTEGER := 16#078#;
    constant ADDR_B_1_DATA_0 : INTEGER := 16#07c#;
    constant ADDR_B_1_DATA_1 : INTEGER := 16#080#;
    constant ADDR_B_1_CTRL   : INTEGER := 16#084#;
    constant ADDR_B_2_DATA_0 : INTEGER := 16#088#;
    constant ADDR_B_2_DATA_1 : INTEGER := 16#08c#;
    constant ADDR_B_2_CTRL   : INTEGER := 16#090#;
    constant ADDR_B_3_DATA_0 : INTEGER := 16#094#;
    constant ADDR_B_3_DATA_1 : INTEGER := 16#098#;
    constant ADDR_B_3_CTRL   : INTEGER := 16#09c#;
    constant ADDR_B_4_DATA_0 : INTEGER := 16#0a0#;
    constant ADDR_B_4_DATA_1 : INTEGER := 16#0a4#;
    constant ADDR_B_4_CTRL   : INTEGER := 16#0a8#;
    constant ADDR_B_5_DATA_0 : INTEGER := 16#0ac#;
    constant ADDR_B_5_DATA_1 : INTEGER := 16#0b0#;
    constant ADDR_B_5_CTRL   : INTEGER := 16#0b4#;
    constant ADDR_B_6_DATA_0 : INTEGER := 16#0b8#;
    constant ADDR_B_6_DATA_1 : INTEGER := 16#0bc#;
    constant ADDR_B_6_CTRL   : INTEGER := 16#0c0#;
    constant ADDR_B_7_DATA_0 : INTEGER := 16#0c4#;
    constant ADDR_B_7_DATA_1 : INTEGER := 16#0c8#;
    constant ADDR_B_7_CTRL   : INTEGER := 16#0cc#;
    constant ADDR_C_0_DATA_0 : INTEGER := 16#0d0#;
    constant ADDR_C_0_DATA_1 : INTEGER := 16#0d4#;
    constant ADDR_C_0_CTRL   : INTEGER := 16#0d8#;
    constant ADDR_C_1_DATA_0 : INTEGER := 16#0dc#;
    constant ADDR_C_1_DATA_1 : INTEGER := 16#0e0#;
    constant ADDR_C_1_CTRL   : INTEGER := 16#0e4#;
    constant ADDR_C_2_DATA_0 : INTEGER := 16#0e8#;
    constant ADDR_C_2_DATA_1 : INTEGER := 16#0ec#;
    constant ADDR_C_2_CTRL   : INTEGER := 16#0f0#;
    constant ADDR_C_3_DATA_0 : INTEGER := 16#0f4#;
    constant ADDR_C_3_DATA_1 : INTEGER := 16#0f8#;
    constant ADDR_C_3_CTRL   : INTEGER := 16#0fc#;
    constant ADDR_C_4_DATA_0 : INTEGER := 16#100#;
    constant ADDR_C_4_DATA_1 : INTEGER := 16#104#;
    constant ADDR_C_4_CTRL   : INTEGER := 16#108#;
    constant ADDR_C_5_DATA_0 : INTEGER := 16#10c#;
    constant ADDR_C_5_DATA_1 : INTEGER := 16#110#;
    constant ADDR_C_5_CTRL   : INTEGER := 16#114#;
    constant ADDR_C_6_DATA_0 : INTEGER := 16#118#;
    constant ADDR_C_6_DATA_1 : INTEGER := 16#11c#;
    constant ADDR_C_6_CTRL   : INTEGER := 16#120#;
    constant ADDR_C_7_DATA_0 : INTEGER := 16#124#;
    constant ADDR_C_7_DATA_1 : INTEGER := 16#128#;
    constant ADDR_C_7_CTRL   : INTEGER := 16#12c#;
    constant ADDR_BITS         : INTEGER := 9;

    signal AWREADY_t           : STD_LOGIC;
    signal WREADY_t            : STD_LOGIC;
    signal ARREADY_t           : STD_LOGIC;
    signal RVALID_t            : STD_LOGIC;
    signal BVALID_t            : STD_LOGIC;
    signal waddr               : UNSIGNED(ADDR_BITS-1 downto 0);
    signal wmask               : UNSIGNED(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal aw_hs               : STD_LOGIC;
    signal w_hs                : STD_LOGIC;
    signal rdata_data          : UNSIGNED(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal ar_hs               : STD_LOGIC;
    signal raddr               : UNSIGNED(ADDR_BITS-1 downto 0);
    -- internal registers
    signal int_ap_idle         : STD_LOGIC := '0';
    signal int_ap_continue     : STD_LOGIC := '0';
    signal int_ap_ready        : STD_LOGIC := '0';
    signal task_ap_ready       : STD_LOGIC;
    signal int_ap_done         : STD_LOGIC := '0';
    signal task_ap_done        : STD_LOGIC;
    signal int_task_ap_done    : STD_LOGIC := '0';
    signal int_ap_start        : STD_LOGIC := '0';
    signal int_interrupt       : STD_LOGIC := '0';
    signal int_auto_restart    : STD_LOGIC := '0';
    signal auto_restart_status : STD_LOGIC := '0';
    signal auto_restart_done   : STD_LOGIC := '0';
    signal int_gie             : STD_LOGIC := '0';
    signal int_ier             : UNSIGNED(1 downto 0) := (others => '0');
    signal int_isr             : UNSIGNED(1 downto 0) := (others => '0');
    signal int_a_0             : UNSIGNED(63 downto 0) := (others => '0');
    signal int_a_1             : UNSIGNED(63 downto 0) := (others => '0');
    signal int_a_2             : UNSIGNED(63 downto 0) := (others => '0');
    signal int_a_3             : UNSIGNED(63 downto 0) := (others => '0');
    signal int_a_4             : UNSIGNED(63 downto 0) := (others => '0');
    signal int_a_5             : UNSIGNED(63 downto 0) := (others => '0');
    signal int_a_6             : UNSIGNED(63 downto 0) := (others => '0');
    signal int_a_7             : UNSIGNED(63 downto 0) := (others => '0');
    signal int_b_0             : UNSIGNED(63 downto 0) := (others => '0');
    signal int_b_1             : UNSIGNED(63 downto 0) := (others => '0');
    signal int_b_2             : UNSIGNED(63 downto 0) := (others => '0');
    signal int_b_3             : UNSIGNED(63 downto 0) := (others => '0');
    signal int_b_4             : UNSIGNED(63 downto 0) := (others => '0');
    signal int_b_5             : UNSIGNED(63 downto 0) := (others => '0');
    signal int_b_6             : UNSIGNED(63 downto 0) := (others => '0');
    signal int_b_7             : UNSIGNED(63 downto 0) := (others => '0');
    signal int_c_0             : UNSIGNED(63 downto 0) := (others => '0');
    signal int_c_1             : UNSIGNED(63 downto 0) := (others => '0');
    signal int_c_2             : UNSIGNED(63 downto 0) := (others => '0');
    signal int_c_3             : UNSIGNED(63 downto 0) := (others => '0');
    signal int_c_4             : UNSIGNED(63 downto 0) := (others => '0');
    signal int_c_5             : UNSIGNED(63 downto 0) := (others => '0');
    signal int_c_6             : UNSIGNED(63 downto 0) := (others => '0');
    signal int_c_7             : UNSIGNED(63 downto 0) := (others => '0');


begin
-- ----------------------- Instantiation------------------


-- ----------------------- AXI WRITE ---------------------
    AWREADY_t <=  '1' when wstate = wridle else '0';
    AWREADY   <=  AWREADY_t;
    WREADY_t  <=  '1' when wstate = wrdata else '0';
    WREADY    <=  WREADY_t;
    BVALID_t  <=  '1' when wstate = wrresp else '0';
    BVALID    <=  BVALID_t;
    BRESP     <=  "00";  -- OKAY
    wmask     <=  (31 downto 24 => WSTRB(3), 23 downto 16 => WSTRB(2), 15 downto 8 => WSTRB(1), 7 downto 0 => WSTRB(0));
    aw_hs     <=  AWVALID and AWREADY_t;
    w_hs      <=  WVALID and WREADY_t;

    -- write FSM
    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                wstate <= wrreset;
            elsif (ACLK_EN = '1') then
                wstate <= wnext;
            end if;
        end if;
    end process;

    process (wstate, AWVALID, WVALID, BREADY, BVALID_t)
    begin
        case (wstate) is
        when wridle =>
            if (AWVALID = '1') then
                wnext <= wrdata;
            else
                wnext <= wridle;
            end if;
        when wrdata =>
            if (WVALID = '1') then
                wnext <= wrresp;
            else
                wnext <= wrdata;
            end if;
        when wrresp =>
            if (BREADY = '1' and BVALID_t = '1') then
                wnext <= wridle;
            else
                wnext <= wrresp;
            end if;
        when others =>
            wnext <= wridle;
        end case;
    end process;

    waddr_proc : process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ACLK_EN = '1') then
                if (aw_hs = '1') then
                    waddr <= UNSIGNED(AWADDR(ADDR_BITS-1 downto 2) & (1 downto 0 => '0'));
                end if;
            end if;
        end if;
    end process;

-- ----------------------- AXI READ ----------------------
    ARREADY_t <= '1' when (rstate = rdidle) else '0';
    ARREADY <= ARREADY_t;
    RDATA   <= STD_LOGIC_VECTOR(rdata_data);
    RRESP   <= "00";  -- OKAY
    RVALID_t  <= '1' when (rstate = rddata) else '0';
    RVALID    <= RVALID_t;
    ar_hs   <= ARVALID and ARREADY_t;
    raddr   <= UNSIGNED(ARADDR(ADDR_BITS-1 downto 0));

    -- read FSM
    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                rstate <= rdreset;
            elsif (ACLK_EN = '1') then
                rstate <= rnext;
            end if;
        end if;
    end process;

    process (rstate, ARVALID, RREADY, RVALID_t)
    begin
        case (rstate) is
        when rdidle =>
            if (ARVALID = '1') then
                rnext <= rddata;
            else
                rnext <= rdidle;
            end if;
        when rddata =>
            if (RREADY = '1' and RVALID_t = '1') then
                rnext <= rdidle;
            else
                rnext <= rddata;
            end if;
        when others =>
            rnext <= rdidle;
        end case;
    end process;

    rdata_proc : process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ACLK_EN = '1') then
                if (ar_hs = '1') then
                    rdata_data <= (others => '0');
                    case (TO_INTEGER(raddr)) is
                    when ADDR_AP_CTRL =>
                        rdata_data(9) <= int_interrupt;
                        rdata_data(7) <= int_auto_restart;
                        rdata_data(4) <= int_ap_continue;
                        rdata_data(3) <= int_ap_ready;
                        rdata_data(2) <= int_ap_idle;
                        rdata_data(1) <= int_task_ap_done;
                        rdata_data(0) <= int_ap_start;
                    when ADDR_GIE =>
                        rdata_data(0) <= int_gie;
                    when ADDR_IER =>
                        rdata_data(1 downto 0) <= int_ier;
                    when ADDR_ISR =>
                        rdata_data(1 downto 0) <= int_isr;
                    when ADDR_A_0_DATA_0 =>
                        rdata_data <= RESIZE(int_a_0(31 downto 0), 32);
                    when ADDR_A_0_DATA_1 =>
                        rdata_data <= RESIZE(int_a_0(63 downto 32), 32);
                    when ADDR_A_1_DATA_0 =>
                        rdata_data <= RESIZE(int_a_1(31 downto 0), 32);
                    when ADDR_A_1_DATA_1 =>
                        rdata_data <= RESIZE(int_a_1(63 downto 32), 32);
                    when ADDR_A_2_DATA_0 =>
                        rdata_data <= RESIZE(int_a_2(31 downto 0), 32);
                    when ADDR_A_2_DATA_1 =>
                        rdata_data <= RESIZE(int_a_2(63 downto 32), 32);
                    when ADDR_A_3_DATA_0 =>
                        rdata_data <= RESIZE(int_a_3(31 downto 0), 32);
                    when ADDR_A_3_DATA_1 =>
                        rdata_data <= RESIZE(int_a_3(63 downto 32), 32);
                    when ADDR_A_4_DATA_0 =>
                        rdata_data <= RESIZE(int_a_4(31 downto 0), 32);
                    when ADDR_A_4_DATA_1 =>
                        rdata_data <= RESIZE(int_a_4(63 downto 32), 32);
                    when ADDR_A_5_DATA_0 =>
                        rdata_data <= RESIZE(int_a_5(31 downto 0), 32);
                    when ADDR_A_5_DATA_1 =>
                        rdata_data <= RESIZE(int_a_5(63 downto 32), 32);
                    when ADDR_A_6_DATA_0 =>
                        rdata_data <= RESIZE(int_a_6(31 downto 0), 32);
                    when ADDR_A_6_DATA_1 =>
                        rdata_data <= RESIZE(int_a_6(63 downto 32), 32);
                    when ADDR_A_7_DATA_0 =>
                        rdata_data <= RESIZE(int_a_7(31 downto 0), 32);
                    when ADDR_A_7_DATA_1 =>
                        rdata_data <= RESIZE(int_a_7(63 downto 32), 32);
                    when ADDR_B_0_DATA_0 =>
                        rdata_data <= RESIZE(int_b_0(31 downto 0), 32);
                    when ADDR_B_0_DATA_1 =>
                        rdata_data <= RESIZE(int_b_0(63 downto 32), 32);
                    when ADDR_B_1_DATA_0 =>
                        rdata_data <= RESIZE(int_b_1(31 downto 0), 32);
                    when ADDR_B_1_DATA_1 =>
                        rdata_data <= RESIZE(int_b_1(63 downto 32), 32);
                    when ADDR_B_2_DATA_0 =>
                        rdata_data <= RESIZE(int_b_2(31 downto 0), 32);
                    when ADDR_B_2_DATA_1 =>
                        rdata_data <= RESIZE(int_b_2(63 downto 32), 32);
                    when ADDR_B_3_DATA_0 =>
                        rdata_data <= RESIZE(int_b_3(31 downto 0), 32);
                    when ADDR_B_3_DATA_1 =>
                        rdata_data <= RESIZE(int_b_3(63 downto 32), 32);
                    when ADDR_B_4_DATA_0 =>
                        rdata_data <= RESIZE(int_b_4(31 downto 0), 32);
                    when ADDR_B_4_DATA_1 =>
                        rdata_data <= RESIZE(int_b_4(63 downto 32), 32);
                    when ADDR_B_5_DATA_0 =>
                        rdata_data <= RESIZE(int_b_5(31 downto 0), 32);
                    when ADDR_B_5_DATA_1 =>
                        rdata_data <= RESIZE(int_b_5(63 downto 32), 32);
                    when ADDR_B_6_DATA_0 =>
                        rdata_data <= RESIZE(int_b_6(31 downto 0), 32);
                    when ADDR_B_6_DATA_1 =>
                        rdata_data <= RESIZE(int_b_6(63 downto 32), 32);
                    when ADDR_B_7_DATA_0 =>
                        rdata_data <= RESIZE(int_b_7(31 downto 0), 32);
                    when ADDR_B_7_DATA_1 =>
                        rdata_data <= RESIZE(int_b_7(63 downto 32), 32);
                    when ADDR_C_0_DATA_0 =>
                        rdata_data <= RESIZE(int_c_0(31 downto 0), 32);
                    when ADDR_C_0_DATA_1 =>
                        rdata_data <= RESIZE(int_c_0(63 downto 32), 32);
                    when ADDR_C_1_DATA_0 =>
                        rdata_data <= RESIZE(int_c_1(31 downto 0), 32);
                    when ADDR_C_1_DATA_1 =>
                        rdata_data <= RESIZE(int_c_1(63 downto 32), 32);
                    when ADDR_C_2_DATA_0 =>
                        rdata_data <= RESIZE(int_c_2(31 downto 0), 32);
                    when ADDR_C_2_DATA_1 =>
                        rdata_data <= RESIZE(int_c_2(63 downto 32), 32);
                    when ADDR_C_3_DATA_0 =>
                        rdata_data <= RESIZE(int_c_3(31 downto 0), 32);
                    when ADDR_C_3_DATA_1 =>
                        rdata_data <= RESIZE(int_c_3(63 downto 32), 32);
                    when ADDR_C_4_DATA_0 =>
                        rdata_data <= RESIZE(int_c_4(31 downto 0), 32);
                    when ADDR_C_4_DATA_1 =>
                        rdata_data <= RESIZE(int_c_4(63 downto 32), 32);
                    when ADDR_C_5_DATA_0 =>
                        rdata_data <= RESIZE(int_c_5(31 downto 0), 32);
                    when ADDR_C_5_DATA_1 =>
                        rdata_data <= RESIZE(int_c_5(63 downto 32), 32);
                    when ADDR_C_6_DATA_0 =>
                        rdata_data <= RESIZE(int_c_6(31 downto 0), 32);
                    when ADDR_C_6_DATA_1 =>
                        rdata_data <= RESIZE(int_c_6(63 downto 32), 32);
                    when ADDR_C_7_DATA_0 =>
                        rdata_data <= RESIZE(int_c_7(31 downto 0), 32);
                    when ADDR_C_7_DATA_1 =>
                        rdata_data <= RESIZE(int_c_7(63 downto 32), 32);
                    when others =>
                        NULL;
                    end case;
                end if;
            end if;
        end if;
    end process;

-- ----------------------- Register logic ----------------
    interrupt            <= int_interrupt;
    ap_start             <= int_ap_start;
    task_ap_done         <= (ap_done and not auto_restart_status) or auto_restart_done;
    task_ap_ready        <= ap_ready and not int_auto_restart;
    ap_continue          <= int_ap_continue or auto_restart_status;
    a_0                  <= STD_LOGIC_VECTOR(int_a_0);
    a_1                  <= STD_LOGIC_VECTOR(int_a_1);
    a_2                  <= STD_LOGIC_VECTOR(int_a_2);
    a_3                  <= STD_LOGIC_VECTOR(int_a_3);
    a_4                  <= STD_LOGIC_VECTOR(int_a_4);
    a_5                  <= STD_LOGIC_VECTOR(int_a_5);
    a_6                  <= STD_LOGIC_VECTOR(int_a_6);
    a_7                  <= STD_LOGIC_VECTOR(int_a_7);
    b_0                  <= STD_LOGIC_VECTOR(int_b_0);
    b_1                  <= STD_LOGIC_VECTOR(int_b_1);
    b_2                  <= STD_LOGIC_VECTOR(int_b_2);
    b_3                  <= STD_LOGIC_VECTOR(int_b_3);
    b_4                  <= STD_LOGIC_VECTOR(int_b_4);
    b_5                  <= STD_LOGIC_VECTOR(int_b_5);
    b_6                  <= STD_LOGIC_VECTOR(int_b_6);
    b_7                  <= STD_LOGIC_VECTOR(int_b_7);
    c_0                  <= STD_LOGIC_VECTOR(int_c_0);
    c_1                  <= STD_LOGIC_VECTOR(int_c_1);
    c_2                  <= STD_LOGIC_VECTOR(int_c_2);
    c_3                  <= STD_LOGIC_VECTOR(int_c_3);
    c_4                  <= STD_LOGIC_VECTOR(int_c_4);
    c_5                  <= STD_LOGIC_VECTOR(int_c_5);
    c_6                  <= STD_LOGIC_VECTOR(int_c_6);
    c_7                  <= STD_LOGIC_VECTOR(int_c_7);

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_interrupt <= '0';
            elsif (ACLK_EN = '1') then
                if (int_gie = '1' and (int_isr(0) or int_isr(1)) = '1') then
                    int_interrupt <= '1';
                else
                    int_interrupt <= '0';
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_ap_start <= '0';
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_AP_CTRL and WSTRB(0) = '1' and WDATA(0) = '1') then
                    int_ap_start <= '1';
                elsif (ap_ready = '1') then
                    int_ap_start <= int_auto_restart; -- clear on handshake/auto restart
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_ap_done <= '0';
            elsif (ACLK_EN = '1') then
                if (true) then
                    int_ap_done <= ap_done;
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_task_ap_done <= '0';
            elsif (ACLK_EN = '1') then
                if (int_ap_continue = '1') then
                    int_task_ap_done <= '0';
                elsif (task_ap_done = '1') then
                    int_task_ap_done <= '1';
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_ap_idle <= '0';
            elsif (ACLK_EN = '1') then
                if (true) then
                    int_ap_idle <= ap_idle;
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_ap_ready <= '0';
            elsif (ACLK_EN = '1') then
                if (task_ap_ready = '1') then
                    int_ap_ready <= '1';
                elsif (ar_hs = '1' and raddr = ADDR_AP_CTRL) then
                    int_ap_ready <= '0';
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_ap_continue <= '0';
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_AP_CTRL and WSTRB(0) = '1' and WDATA(4) = '1') then
                    int_ap_continue <= '1';
                else
                    int_ap_continue <= '0'; -- self clear
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_auto_restart <= '0';
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_AP_CTRL and WSTRB(0) = '1') then
                    int_auto_restart <= WDATA(7);
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                auto_restart_status <= '0';
            elsif (ACLK_EN = '1') then
                if (int_auto_restart = '1') then
                    auto_restart_status <= '1';
                elsif (ap_idle = '1') then
                    auto_restart_status <= '0';
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                auto_restart_done <= '0';
            elsif (ACLK_EN = '1') then
                if (auto_restart_status = '1' and (ap_idle = '1' and int_ap_idle = '0')) then
                    auto_restart_done <= '1';
                elsif (int_ap_continue = '1') then
                    auto_restart_done <= '0';
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_gie <= '0';
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_GIE and WSTRB(0) = '1') then
                    int_gie <= WDATA(0);
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_ier <= (others=>'0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_IER and WSTRB(0) = '1') then
                    int_ier <= UNSIGNED(WDATA(1 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_isr(0) <= '0';
            elsif (ACLK_EN = '1') then
                if (int_ier(0) = '1' and ap_done = '1') then
                    int_isr(0) <= '1';
                elsif (w_hs = '1' and waddr = ADDR_ISR and WSTRB(0) = '1') then
                    int_isr(0) <= int_isr(0) xor WDATA(0); -- toggle on write
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_isr(1) <= '0';
            elsif (ACLK_EN = '1') then
                if (int_ier(1) = '1' and ap_ready = '1') then
                    int_isr(1) <= '1';
                elsif (w_hs = '1' and waddr = ADDR_ISR and WSTRB(0) = '1') then
                    int_isr(1) <= int_isr(1) xor WDATA(1); -- toggle on write
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_a_0(31 downto 0) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_A_0_DATA_0) then
                    int_a_0(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_a_0(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_a_0(63 downto 32) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_A_0_DATA_1) then
                    int_a_0(63 downto 32) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_a_0(63 downto 32));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_a_1(31 downto 0) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_A_1_DATA_0) then
                    int_a_1(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_a_1(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_a_1(63 downto 32) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_A_1_DATA_1) then
                    int_a_1(63 downto 32) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_a_1(63 downto 32));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_a_2(31 downto 0) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_A_2_DATA_0) then
                    int_a_2(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_a_2(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_a_2(63 downto 32) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_A_2_DATA_1) then
                    int_a_2(63 downto 32) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_a_2(63 downto 32));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_a_3(31 downto 0) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_A_3_DATA_0) then
                    int_a_3(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_a_3(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_a_3(63 downto 32) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_A_3_DATA_1) then
                    int_a_3(63 downto 32) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_a_3(63 downto 32));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_a_4(31 downto 0) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_A_4_DATA_0) then
                    int_a_4(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_a_4(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_a_4(63 downto 32) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_A_4_DATA_1) then
                    int_a_4(63 downto 32) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_a_4(63 downto 32));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_a_5(31 downto 0) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_A_5_DATA_0) then
                    int_a_5(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_a_5(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_a_5(63 downto 32) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_A_5_DATA_1) then
                    int_a_5(63 downto 32) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_a_5(63 downto 32));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_a_6(31 downto 0) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_A_6_DATA_0) then
                    int_a_6(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_a_6(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_a_6(63 downto 32) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_A_6_DATA_1) then
                    int_a_6(63 downto 32) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_a_6(63 downto 32));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_a_7(31 downto 0) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_A_7_DATA_0) then
                    int_a_7(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_a_7(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_a_7(63 downto 32) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_A_7_DATA_1) then
                    int_a_7(63 downto 32) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_a_7(63 downto 32));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_b_0(31 downto 0) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_B_0_DATA_0) then
                    int_b_0(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_b_0(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_b_0(63 downto 32) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_B_0_DATA_1) then
                    int_b_0(63 downto 32) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_b_0(63 downto 32));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_b_1(31 downto 0) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_B_1_DATA_0) then
                    int_b_1(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_b_1(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_b_1(63 downto 32) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_B_1_DATA_1) then
                    int_b_1(63 downto 32) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_b_1(63 downto 32));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_b_2(31 downto 0) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_B_2_DATA_0) then
                    int_b_2(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_b_2(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_b_2(63 downto 32) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_B_2_DATA_1) then
                    int_b_2(63 downto 32) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_b_2(63 downto 32));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_b_3(31 downto 0) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_B_3_DATA_0) then
                    int_b_3(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_b_3(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_b_3(63 downto 32) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_B_3_DATA_1) then
                    int_b_3(63 downto 32) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_b_3(63 downto 32));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_b_4(31 downto 0) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_B_4_DATA_0) then
                    int_b_4(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_b_4(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_b_4(63 downto 32) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_B_4_DATA_1) then
                    int_b_4(63 downto 32) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_b_4(63 downto 32));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_b_5(31 downto 0) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_B_5_DATA_0) then
                    int_b_5(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_b_5(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_b_5(63 downto 32) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_B_5_DATA_1) then
                    int_b_5(63 downto 32) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_b_5(63 downto 32));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_b_6(31 downto 0) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_B_6_DATA_0) then
                    int_b_6(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_b_6(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_b_6(63 downto 32) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_B_6_DATA_1) then
                    int_b_6(63 downto 32) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_b_6(63 downto 32));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_b_7(31 downto 0) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_B_7_DATA_0) then
                    int_b_7(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_b_7(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_b_7(63 downto 32) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_B_7_DATA_1) then
                    int_b_7(63 downto 32) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_b_7(63 downto 32));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_c_0(31 downto 0) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_C_0_DATA_0) then
                    int_c_0(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_c_0(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_c_0(63 downto 32) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_C_0_DATA_1) then
                    int_c_0(63 downto 32) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_c_0(63 downto 32));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_c_1(31 downto 0) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_C_1_DATA_0) then
                    int_c_1(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_c_1(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_c_1(63 downto 32) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_C_1_DATA_1) then
                    int_c_1(63 downto 32) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_c_1(63 downto 32));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_c_2(31 downto 0) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_C_2_DATA_0) then
                    int_c_2(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_c_2(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_c_2(63 downto 32) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_C_2_DATA_1) then
                    int_c_2(63 downto 32) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_c_2(63 downto 32));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_c_3(31 downto 0) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_C_3_DATA_0) then
                    int_c_3(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_c_3(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_c_3(63 downto 32) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_C_3_DATA_1) then
                    int_c_3(63 downto 32) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_c_3(63 downto 32));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_c_4(31 downto 0) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_C_4_DATA_0) then
                    int_c_4(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_c_4(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_c_4(63 downto 32) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_C_4_DATA_1) then
                    int_c_4(63 downto 32) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_c_4(63 downto 32));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_c_5(31 downto 0) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_C_5_DATA_0) then
                    int_c_5(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_c_5(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_c_5(63 downto 32) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_C_5_DATA_1) then
                    int_c_5(63 downto 32) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_c_5(63 downto 32));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_c_6(31 downto 0) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_C_6_DATA_0) then
                    int_c_6(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_c_6(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_c_6(63 downto 32) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_C_6_DATA_1) then
                    int_c_6(63 downto 32) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_c_6(63 downto 32));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_c_7(31 downto 0) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_C_7_DATA_0) then
                    int_c_7(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_c_7(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_c_7(63 downto 32) <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_C_7_DATA_1) then
                    int_c_7(63 downto 32) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_c_7(63 downto 32));
                end if;
            end if;
        end if;
    end process;


-- ----------------------- Memory logic ------------------

end architecture behave;
