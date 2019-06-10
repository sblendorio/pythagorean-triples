MODULE Pythagoras;

FROM SYSTEM IMPORT BDOS,ADR,IORESULT;

TYPE MATRIX = ARRAY [1..3] OF ARRAY [1..3] OF LONGINT;
     VECTOR = ARRAY [1..3] OF LONGINT;
     RESULTS = ARRAY [1..3] OF VECTOR;
     MATRICES = ARRAY [1..3] OF MATRIX;
     QUEUE = ARRAY [1..3050] OF VECTOR;

VAR value: VECTOR;
    m: MATRICES;
    count: CARDINAL;
    q: QUEUE;
    qtop, qbottom: CARDINAL;
    output: ARRAY[1..20] OF VECTOR;
    lines: CARDINAL;

PROCEDURE BcdToDec(n: INTEGER): INTEGER;
BEGIN
    RETURN (INTEGER(BITSET(n) * BITSET(240)) DIV 16) * 10
          + INTEGER(BITSET(n) * BITSET(15))
END BcdToDec;

PROCEDURE GetTime(): LONGINT;
CONST GetDT = 105; (* BDOS Function *)
VAR dat: ARRAY[0..1] OF CARDINAL;
    hour, minute, second: INTEGER;
BEGIN
    BDOS(GetDT,ADR(dat));
    second := BcdToDec(IORESULT);
    minute := BcdToDec(dat[1] DIV 256);
    hour   := BcdToDec(INTEGER(BITSET(dat[1])*BITSET(65535)));
    RETURN LONG(second) + (LONG(minute)*60L) + (LONG(hour)*3600L)
END GetTime;

PROCEDURE Assign(VAR dest: VECTOR; VAR src: VECTOR);
VAR i: CARDINAL;
BEGIN
    FOR i := 1 TO 3 DO dest[i]:=src[i] END
END Assign;

PROCEDURE Push(VAR element: VECTOR);
BEGIN
    Assign(q[qbottom],element);
    INC(qbottom)
END Push;

PROCEDURE Pull(VAR element: VECTOR);
BEGIN
    Assign(element,q[qtop]);
    INC(qtop)
END Pull;

PROCEDURE Init();
BEGIN
    qtop := 1;
    qbottom := 1;
    count := 0;
    lines := 0;

    value[1] := 3L;
    value[2] := 4L;
    value[3] := 5L;

    m[1][1][1]:=1L; m[1][1][2]:=-2L; m[1][1][3]:=2L;
    m[1][2][1]:=2L; m[1][2][2]:=-1L; m[1][2][3]:=2L;
    m[1][3][1]:=2L; m[1][3][2]:=-2L; m[1][3][3]:=3L;

    m[2][1][1]:=1L; m[2][1][2]:=2L; m[2][1][3]:=2L;
    m[2][2][1]:=2L; m[2][2][2]:=1L; m[2][2][3]:=2L;
    m[2][3][1]:=2L; m[2][3][2]:=2L; m[2][3][3]:=3L;

    m[3][1][1]:=-1L; m[3][1][2]:=2L; m[3][1][3]:=2L;
    m[3][2][1]:=-2L; m[3][2][2]:=1L; m[3][2][3]:=2L;
    m[3][3][1]:=-2L; m[3][3][2]:=2L; m[3][3][3]:=3L;

END Init;

PROCEDURE Print(VAR value: VECTOR);
BEGIN
    WRITELN(value[1], ' ', value[2], ' ', value[3])
END Print;

PROCEDURE Multiply(VAR m: MATRIX; VAR v: VECTOR; VAR result: VECTOR);
VAR i: CARDINAL;
BEGIN
    FOR i := 1 TO 3 DO
        result[i] := m[i][1]*v[1] + m[i][2]*v[2] + m[i][3]*v[3]
    END
END Multiply;

PROCEDURE GetNext3(VAR value: VECTOR; VAR m: MATRICES; VAR r: RESULTS);
VAR i: CARDINAL;
BEGIN
  FOR i := 1 TO 3 DO
      Multiply(m[i], value, r[i])
  END
END GetNext3;

PROCEDURE DoBreadthSearch();
VAR value: VECTOR;
    r: RESULTS;
    i: CARDINAL;
BEGIN
    WHILE count < 1000 DO
        INC(count);
        Pull(value);
        IF count >= 981 THEN
           INC(lines);
           Assign(output[lines], value);
        END;
        GetNext3(value, m, r);
        FOR i := 1 TO 3 DO
            Push(r[i])
        END
    END
END DoBreadthSearch;

VAR i: CARDINAL;
VAR start, end: LONGINT;
BEGIN
    Init();
    Push(value);
    start := GetTime();
    DoBreadthSearch();
    end := GetTime();
    FOR i:=1 TO 20 DO
        Print(output[i])
    END;
    WRITELN();
    WRITE('Took: ', (end-start), ' seconds.');
END Pythagoras.
