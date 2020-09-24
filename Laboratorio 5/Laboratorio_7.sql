-- ===================================================
-- Authors: Alejandro Barrachina, Clara Fernandez
-- Description: act_7
-- ===================================================

SET SERVEROUTPUT ON;


CREATE OR REPLACE PROCEDURE ACTUALIZAR_SOCIOS( EQUIPO CLUB.CIF%TYPE) IS

    /*CONTRARIO VARCHAR(9);
    
    CURSOR cr_cifClub IS SELECT CIF 
                         FROM CLUB
                         WHERE CIF != EQUIPO;*/

    CURSOR cr_enfrentamientos IS  SELECT COUNT(*) numVisitantes, cif_local, cif_visitante
                                  FROM ASISTE
                                  WHERE CIF_LOCAL = EQUIPO OR cif_visitante = EQUIPO
                                  GROUP BY CIF_LOCAL, CIF_VISITANTE;
    INCREMENTO NUMBER := 0;

BEGIN
    DBMS_OUTPUT.PUT_LINE('ACTUALIZANDO NUMERO DE SOCIOS DEL CLUB: ' || EQUIPO);
    DBMS_OUTPUT.PUT_LINE('#############################################################');
    FOR VISITANTES IN CR_ENFRENTAMIENTOS LOOP
        DBMS_OUTPUT.PUT_LINE(VISITANTES.CIF_LOCAL || ' - ' || VISITANTES.CIF_VISITANTE);
        if(VISITANTES.numVisitantes > 0 AND VISITANTES.numVisitantes < 4) THEN
            DBMS_OUTPUT.PUT_LINE(VISITANTES.numVisitantes || ' ASISTENTES -> +10 SOCIOS');
            INCREMENTO := INCREMENTO + 10;
        
        ELSE 
            IF( VISITANTES.numVisitantes > 3) THEN
                DBMS_OUTPUT.PUT_LINE(VISITANTES.numVisitantes || ' ASISTENTES -> +100 SOCIOS');
                INCREMENTO := INCREMENTO + 100;
        
            END IF;
        END IF;
    END LOOP;
    commit;
    DBMS_OUTPUT.PUT_LINE('TOTAL SOCIOS GANADOS: ' || INCREMENTO);
    UPDATE CLUB SET NUM_SOCIOS = NUM_SOCIOS + INCREMENTO WHERE CLUB.CIF = EQUIPO;
END;
/

SET SERVEROUTPUT ON;

BEGIN
    ACTUALIZAR_SOCIOS('11111111X');
END;
/
