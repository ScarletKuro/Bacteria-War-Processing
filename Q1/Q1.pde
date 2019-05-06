class Cell {
 PVector Position;
 color Status;
 Cell(PVector pos, color status) {
  Position = pos;
  Status = status;
 }
 boolean IsInfected() {
  return Status != CellStatus.Healthy;
 }
 void Infect() {
  Status = CellStatus.InfectedRed;
 }
 
 void Infect(color infectedcolor) {
  Status = infectedcolor;
 }
 
}
interface CellStatus {
 color
 Healthy = #000000, 
 InfectedRed = #ff0000;
}

final int SIDE_LENGTH = 10;
final int CANVAS_SIZE = 500;
final int CELL_SIZE = CANVAS_SIZE / SIDE_LENGTH;
Cell[][] Cells = new Cell[SIDE_LENGTH][SIDE_LENGTH];
Cell[][] TempCells = new Cell[SIDE_LENGTH][SIDE_LENGTH];


void setup() {
 settings();
 noStroke();
 frameRate(2);
 int row = 0;
 int col = 0;
 for (int x = 0; x <= width - CELL_SIZE; x += CELL_SIZE) {
  for (int y = 0; y <= height - CELL_SIZE; y += CELL_SIZE) {
   Cells[row][col] = new Cell(new PVector(x, y), CellStatus.Healthy);
   col++;
  }
  col = 0;
  row++;
 }

 InfecRandom();
 DeepCopy();
}

void settings() {
 size(CANVAS_SIZE, CANVAS_SIZE);
}

void draw() {
 drawBoard(#ffffff, #eeeeee);
 drawCells();
 spreadInfection();
}

void drawCells() {
 for (int i = 0; i < Cells.length; i++) {
  for (int j = 0; j < Cells[0].length; j++) {
   Cell cell = Cells[i][j];
   drawSquare(cell.Position, cell.Status);
  }
 }
}

void InfecRandom() {
 int nbrCols = Cells.length;
 int nbrRows = Cells[0].length;
 Cell randomCell = Cells[(int) random(nbrCols)][(int) random(nbrRows)];
 randomCell.Infect();
}


void Infect(int row, int col, color infectedcolor) {
 if (!checkIfOutOfSide(row, col)) {
  Cell cell = Cells[row][col];
  if (!cell.IsInfected()) { //check if not infected
   cell.Infect(infectedcolor);
  }
 }

}

void spreadInfection() {
 for (int i = 0; i < TempCells.length; i++) {
  for (int j = 0; j < TempCells[0].length; j++) {
   Cell cell = TempCells[i][j];
   if (cell.IsInfected()) { //a loop that will find all the infected cells
    Infect(i + 1, j, cell.Status);
    Infect(i - 1, j, cell.Status);
    Infect(i, j + 1, cell.Status);
    Infect(i, j - 1, cell.Status);
   }
  }
 }
 DeepCopy();
}

void DeepCopy() {
 TempCells = new Cell[SIDE_LENGTH][SIDE_LENGTH];
 for (int i = 0; i < Cells.length; i++) {
  for (int j = 0; j < Cells[0].length; j++) {
   Cell cell = Cells[i][j];
   TempCells[i][j] = new Cell(cell.Position, cell.Status);
  }
 }
}

void drawSquare(PVector vector, color squarecolor) {
 stroke(#eeeeee);
 fill(squarecolor);
 rect(vector.x, vector.y, CELL_SIZE, CELL_SIZE);
}

void drawBoard(color color1, color color2) {
 fill(color1);
 stroke(color2);
 rect(0, 0, height, width);
 for (float x = 0.5; x < width; x += CELL_SIZE) {
  line(x, 0, x, height);
 }
 for (float y = 0.5; y < height; y += CELL_SIZE) {
  line(0, y, width, y);
 }

 stroke(0);
}

boolean checkIfOutOfSide(int row, int col) {
 return (row >= SIDE_LENGTH || row < 0) || (col >= SIDE_LENGTH || col < 0);
}
