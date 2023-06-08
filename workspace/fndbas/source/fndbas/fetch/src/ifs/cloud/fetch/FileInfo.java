package ifs.cloud.fetch;

public class FileInfo {

   private int size;
   private String type;
   private String path;

   protected void setSize(int size) {
      this.size = size;
   }

   protected void setType(String type) {
      this.type = type;
   }

   protected void setPath(String path) {
      this.path = path;
   }

   public int getSize() {
      return size;
   }

   public String getType() {
      return type;
   }

   public String getPath() {
      return path;
   }
   
   @Override
   public String toString() {
      StringBuilder sb = new StringBuilder();
      sb.append("path: ").append(path).append("\n");
      sb.append("type: ").append(type).append("\n");;
      sb.append("size: ").append(size).append("bytes\n");;
      return sb.toString();
   }
}
