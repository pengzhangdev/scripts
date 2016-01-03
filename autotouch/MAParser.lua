function error(err)
    -- Replace with your own error output method:
    print(err);
end

function log(info)
   print(info)
end

function rootDir()
   return './'
end

function ReadWORD(str, offset)
    local loByte = str:byte(offset);
    local hiByte = str:byte(offset+1);
    return hiByte*256 + loByte;
end

-- Helper function: Parse a 32-bit DWORD from the binary string
function ReadDWORD(str, offset)
    local loWord = ReadWORD(str, offset);
    local hiWord = ReadWORD(str, offset+2);
    return hiWord*65536 + loWord;
end

function roundup(num, idp)
   if num % idp == 0 then
      return num
   end

   mul = math.floor(num / idp) + 1
   return mul * idp
end

function OpenBitmap(File, Stream)
    if Stream == nil then Stream = false end
    local bytecode = File:read("*a")

    -------------------------
    -- Parse BITMAPFILEHEADER
    -------------------------
    local offset = 1;
    local bfType = ReadWORD(bytecode, offset);
    if(bfType ~= 0x4D42) then
        error("Not a bitmap file (Invalid BMP magic value)");
        return;
    end
    local bfOffBits = ReadWORD(bytecode, offset+10);

    -------------------------
    -- Parse BITMAPINFOHEADER
    -------------------------
    offset = 15; -- BITMAPFILEHEADER is 14 bytes long
    local biWidth = ReadDWORD(bytecode, offset+4);
    local biHeight = ReadDWORD(bytecode, offset+8);
    local biBitCount = ReadWORD(bytecode, offset+14);
    local biCompression = ReadDWORD(bytecode, offset+16);
    biWidth = roundup(biWidth, 4)

    if(biBitCount ~= 32) then
        error("Only 24-bit bitmaps supported (Is " .. biBitCount .. "bpp)");
        return;
    end

    if(biCompression ~= 0) then
        error("Only uncompressed bitmaps supported (Compression type is " .. biCompression .. ")");
        return;
    end

    ---------------------
    -- Parse bitmap image
    ---------------------
    local TmpImg = {}
    if Stream == false then
        for y = biHeight-1, 0, -1 do
            offset = bfOffBits + (biWidth * biBitCount / 8) * y + 1;
            for x = 0, biWidth - 1 do
                local b = bytecode:byte(offset);
                local g = bytecode:byte(offset+1);
                local r = bytecode:byte(offset+2);
                local a = bytecode:byte(offset + 3)
                offset = offset + 4;

                TmpImg[#TmpImg+1] = {r, g, b, a}
            end
        end
    else
        for y = biHeight - 1, 0, -1 do
            offset = bfOffBits + (biWidth*biBitCount/8)*y + 1;
            for x = 0, biWidth-1 do
                local b = bytecode:byte(offset);
                local g = bytecode:byte(offset+1);
                local r = bytecode:byte(offset+2);
                local a = bytecode:byte(offset + 3)
                offset = offset + 4;

                TmpImg[#TmpImg+1] = r
                TmpImg[#TmpImg+1] = g
                TmpImg[#TmpImg+1] = b
                TmpImg[#TmpImg+1] = a
            end
        end
    end

    return TmpImg, biWidth, biHeight
end

function OpenBmp(FileName, Stream)
    if Stream == nil then Stream = false end
    if FileName == nil then
        return false
    end

    local File = assert(io.open(FileName, 'rb'))
    local Data, Width, Height = OpenBitmap(File, Stream)

    File:close()
    return Data, Width, Height
end

log (os.date())
local data, width, height = OpenBmp(rootDir() .. "/card.bmp")
for i, v in pairs(data) do
   
end
log (os.date())
