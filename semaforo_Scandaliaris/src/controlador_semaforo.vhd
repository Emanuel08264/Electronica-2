library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controlador_semaforo is
    generic(CLK_FREQ : integer := 12000000);
    port(
        clk, nreset: in std_logic;
        eeo, ens, peo, pns: in std_logic;
        done: in std_logic;
        peor, pnsr: out std_logic;
        reload: out std_logic_vector(5 downto 0);
        luz_eo, luz_ns: out std_logic_vector(2 downto 0)
    );
end controlador_semaforo;

architecture impl of controlador_semaforo is
    constant S_INICIO: std_logic_vector(2 downto 0) := "000";
    constant S_CV_EO: std_logic_vector(2 downto 0) := "001";
    constant S_T_EONS: std_logic_vector(2 downto 0) := "010";
    constant S_CVA_EO: std_logic_vector(2 downto 0) := "011";
    constant S_CV_NS: std_logic_vector(2 downto 0) := "100";
    constant S_T_NSEO: std_logic_vector(2 downto 0) := "101";
    constant S_CVA_NS: std_logic_vector(2 downto 0) := "110";
    constant L_ROJO: std_logic_vector(2 downto 0) := "001";
    constant L_AMARILLO: std_logic_vector(2 downto 0) := "010";
    constant L_VERDE: std_logic_vector(2 downto 0) := "100";
    constant T_10S: std_logic_vector(5 downto 0) := "001010";
    constant T_50S: std_logic_vector(5 downto 0) := "110010";
    signal est_act, est_sig: std_logic_vector(2 downto 0);
    signal peo_k, pns_k, peo_act, pns_act : std_logic;
    signal hab_1Hz std_logic;


begin

    generic map (DIVISOR => CLK_FREQ)
    port map (clk => clk, rst => rst, tic => hab_1Hz);

    -- Codificacion priodidad de entradas
    eeo <= emergencia_1;
    ens <= not emergencia_1 and emergencia_2;
    peo <= (not emergencia_1) and (not emergencia_2) and peatonal_1;
    pns <= (not emergencia_1) and (not emergencia_2) and (not peatonal_1) and peatonal_2;

    -- Registro pedidos peatonales
    -- Implementado mediante flip-flops JK
    ffs: process (clk)
    begin
        if rising_edge(clk) then
            pns_act <= pns_sig;
            peo_act <= peo_sig;
        end if;
    end process;

    -- Logica de ff JK
    peo => J;
    peo_k => K;
    peo_sig <= '0' when rst else
                (peo and not peo_act) or (not peo_k and peo_act);
    pns_sig <= '0' when rst else
                (pns and not pns_act) or (not pns_k and pns_act);

    -- REGISTRO
    memoria_estado_mef: process(clk)
    begin
        if rising_edge(clk) then
            est_act <= est_sig;
        end if;
    end process;

    t1: entity timer
    generic map (TWIDTH => 6)
    port map(
            clk => clk;
            nreset => nreset_timer;
            reload => reload;
            hab => hab_1Hz
            done => done
    );
    
    --LES (combinacional)
    les: process(all) -- process(all) generalmente logica combinacional
    begin
        -- asignacion por defecto
        est_sig <= est_act;
        case est_actual is
            when S_INICIO => 
                if done then
                    est_sig <= CV_EO;
                end if;
            when S_CV_EO =>
                if eeo then
                    est_sig <= S_CV_EO;
                else if ens then
                    est_sig <= S_T_EONS;
                else if done and not pns_act then
                    est_sig <= S_T_EONS;
                else if done and pns_act then
                    est_sig <=  S_CVA_EO;    
                end if;                 
            when S_T_EONS =>
                if eeo and done then
                    est_sig <= S_CV_EO;
                else if donde then
                    est_sig <= S_CV_NS; 
            when S_CVA_EO => 
                if done then
                    est_sig <= S_T_EONS;
            when S_CV_NS =>
                 
            when S_T_NSEO => 
            when S_CVA_NS =>                      
        end case;    
    end process;
    
    -- LS (combinacional)
        peo_k <= '0';
        pns_k <= '0';

        when S_INICIO => 
            luz_eo <= L_ROJO;
            luz_ns <= L_ROJO;
            reload <= T_10S;
        when S_CV_EO =>
            luz_eo <= L_VERDE;
            luz_ns <= L_ROJO;
            reload <= T_50S;            
        when S_T_EONS =>
            luz_eo <= L_AMARILLO;
            luz_ns <= L_ROJO;
            reload <= T_10S;
        when S_CVA_EO =>
            luz_eo <= L_VERDE;
            luz_ns <= L_ROJO;
            reload <= T_50S;
            pns_k <=  '1'; 
        when S_CV_NS =>
            luz_eo <= L_ROJO;
            luz_ns <= L_VERDE;
            reload <= T_50S;
        when S_T_NSEO =>
            luz_eo <= L_ROJO;
            luz_ns <= L_AMARILLO;
            reload <= T_10S; 
        when S_CVA_NS =>
            luz_eo <= L_ROJO;
            luz_ns <= L_VERDE;
            reload <= T_50S;
    
        nreset_temporizador <= '0' when nreset else
                                '0' when est_sig /= est_act else
                                '1'; 
        
        display (0) <= luz_eo(0);
        display (1) <= luz_ns(2);
        display (2) <= luz_ns(1);
        display (3) <= luz_ns(0);
        display (4) <= luz_eo(2);
        display (5) <= luz_eo(1);
        display (6) <= luz_peatonal_eo;
        display (7) <= luz_peatonal_ns;

end impl;