<%@ page pageEncoding="utf-8"%>
<!doctype html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Food Manage</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    />
    <script>
      tailwind.config = {
        theme: {
          extend: {
            colors: {
              darkBg: "#1C1E32",
              primaryYellow: "#F2C94C",
              lightBg: "#F9F9F9",
              cardDark: "#23253E",
            },
          },
        },
      };
    </script>
  </head>
  <body class="bg-lightBg font-sans text-gray-800 antialiased">
    <header class="bg-darkBg text-white border-b border-gray-700">
      <div
        class="container mx-auto px-6 py-4 flex items-center justify-between"
      >
        <div class="flex items-center gap-3">
          <div
            class="w-10 h-10 bg-white rounded-full flex items-center justify-center text-orange-500 font-bold text-xl"
          >
            <i class="fa-solid fa-bowl-food"></i>
          </div>
          <div>
            <h1 class="font-bold text-xl leading-tight">FOOD MANAGE</h1>
            <p class="text-[10px] text-gray-400">FOOD & LIFESTYLE</p>
          </div>
        </div>

        <nav class="hidden md:flex items-center gap-6 text-sm font-medium">
          <a
            href="#"
            class="text-primaryYellow border-b-2 border-primaryYellow pb-1"
            >Trang chủ</a
          >
          <a href="#" class="text-gray-300 hover:text-white">Cửa hàng</a>
          <a href="#" class="text-gray-300 hover:text-white">Món ăn</a>
          <a href="#" class="text-gray-300 hover:text-white">Về chúng tôi</a>
          <a href="#" class="text-gray-300 hover:text-white">Liên hệ</a>
        </nav>

        <div class="flex items-center gap-4">
          <div class="relative hidden lg:block">
            <i
              class="fa-solid fa-search absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400"
            ></i>
            <input
              type="text"
              placeholder="Tìm kiếm món ăn..."
              class="bg-gray-800 text-sm text-white rounded-full py-2 pl-10 pr-4 focus:outline-none focus:ring-1 focus:ring-primaryYellow"
            />
          </div>
          <button
            class="w-10 h-10 bg-gray-800 rounded-full flex items-center justify-center hover:bg-gray-700"
          >
            <i class="fa-solid fa-shopping-cart"></i>
          </button>
          <button
            class="border border-gray-500 text-white px-4 py-2 rounded-full text-sm font-medium hover:border-white"
          >
            <a href="/dangnhap">Đăng nhập</a>
          </button>
          <a href="/dangky"
             class="bg-primaryYellow text-black px-4 py-2 rounded-full text-sm font-medium hover:bg-yellow-500">
              Đăng Ký
          </a>
        </div>
      </div>
    </header>

    <section class="bg-darkBg text-white relative overflow-hidden">
      <div
        class="container mx-auto px-6 py-16 lg:py-24 grid lg:grid-cols-2 gap-10 relative z-10"
      >
        <div>
          <span
            class="inline-block border border-gray-600 bg-gray-800/50 rounded-full px-3 py-1 text-xs font-semibold text-gray-300 mb-6"
          >
            <i class="fa-solid fa-star text-primaryYellow mr-1"></i> GUEST •
            KHÁCH
          </span>
          <h2 class="text-5xl lg:text-6xl font-bold leading-tight mb-6">
            Khám phá ẩm thực<br />
            <span class="text-primaryYellow">Food Manage</span> cùng bạn
          </h2>
          <p class="text-gray-400 mb-8 max-w-md leading-relaxed">
            Tìm kiếm món ăn ngon, khám phá cửa hàng gần bạn và đặt hàng dễ dàng
            trong vài bước.
          </p>
          <div class="flex flex-wrap items-center gap-4 mb-12">
            <button
              class="bg-primaryYellow text-black px-6 py-3 rounded-xl font-semibold hover:bg-yellow-500 shadow-lg"
            >
              Khám phá ngay
            </button>
            <button
              class="border border-gray-600 px-6 py-3 rounded-xl font-semibold hover:bg-gray-800 flex items-center gap-2"
            >
              <i class="fa-solid fa-store"></i> Xem cửa hàng
            </button>
          </div>
          <div class="flex items-center gap-10">
            <div>
              <div class="text-3xl font-bold text-primaryYellow">50+</div>
              <div class="text-sm text-gray-400">Cửa hàng</div>
            </div>
            <div>
              <div class="text-3xl font-bold text-primaryYellow">500+</div>
              <div class="text-sm text-gray-400">Món ăn</div>
            </div>
            <div>
              <div class="text-3xl font-bold text-primaryYellow">
                4.8<i class="fa-solid fa-star text-xl ml-1"></i>
              </div>
              <div class="text-sm text-gray-400">Đánh giá TB</div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <div class="container mx-auto px-6 relative z-20 -mt-10">
      <div>
        <div
          class="flex items-center gap-3 flex-1 min-w-[250px] border-r border-gray-700 pr-4"
        ></div>
        <div class="flex items-center gap-2 flex-1"></div>
      </div>
    </div>

    <section class="container mx-auto px-6 py-16">
      <div
        class="flex justify-between items-end mb-8 border-b-2 border-primaryYellow inline-block pb-2 w-full max-w-[max-content]"
      >
        <div>
          <p
            class="text-primaryYellow font-bold text-xs uppercase tracking-wider mb-1"
          >
            Cửa hàng nổi bật
          </p>
          <h3 class="text-2xl font-bold text-gray-900">Khám phá cửa hàng</h3>
        </div>
        <a
          href="#"
          class="text-sm font-semibold text-gray-700 hover:text-black absolute right-6"
          >Xem tất cả <i class="fa-solid fa-arrow-right"></i
        ></a>
      </div>

      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <div
          class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden hover:shadow-md transition"
        >
          <div
            class="h-32 bg-gradient-to-r from-blue-900 to-indigo-900 relative p-4"
          >
            <span
              class="absolute top-3 right-3 bg-white text-green-600 text-[10px] font-bold px-2 py-1 rounded-full flex items-center gap-1"
              ><span class="w-1.5 h-1.5 bg-green-500 rounded-full"></span
              >OPEN</span
            >
            <div
              class="w-12 h-12 bg-white/10 rounded-full flex items-center justify-center mt-4"
            >
              <i class="fa-solid fa-shop text-white"></i>
            </div>
          </div>
          <div class="p-4">
            <h4 class="font-bold text-lg mb-1">Verdant Hà Nội</h4>
            <div class="flex items-center text-xs text-gray-500 mb-2">
              <div class="text-primaryYellow mr-2">
                <i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i
                ><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i
                ><i class="fa-solid fa-star-half-stroke"></i>
              </div>
              4.9 (342 đánh giá)
            </div>
            <p class="text-xs text-gray-400 mb-3 truncate">
              Hoàn Kiếm, Hà Nội - Giao trong 25 phút
            </p>
            <div class="flex gap-2">
              <span
                class="bg-blue-50 text-blue-600 text-[10px] px-2 py-1 rounded-md"
                >Cơm</span
              >
              <span
                class="bg-green-50 text-green-600 text-[10px] px-2 py-1 rounded-md"
                >Phở</span
              >
              <span
                class="bg-orange-50 text-orange-600 text-[10px] px-2 py-1 rounded-md"
                >Bánh mì</span
              >
            </div>
          </div>
        </div>

        <div
          class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden hover:shadow-md transition"
        >
          <div
            class="h-32 bg-gradient-to-r from-green-900 to-emerald-900 relative p-4"
          >
            <span
              class="absolute top-3 right-3 bg-white text-green-600 text-[10px] font-bold px-2 py-1 rounded-full flex items-center gap-1"
              ><span class="w-1.5 h-1.5 bg-green-500 rounded-full"></span
              >OPEN</span
            >
            <div
              class="w-12 h-12 bg-white/10 rounded-full flex items-center justify-center mt-4"
            >
              <i class="fa-solid fa-shop text-white"></i>
            </div>
          </div>
          <div class="p-4">
            <h4 class="font-bold text-lg mb-1">Verdant Sài Gòn</h4>
            <div class="flex items-center text-xs text-gray-500 mb-2">
              <div class="text-primaryYellow mr-2">
                <i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i
                ><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i
                ><i class="fa-solid fa-star-half-stroke"></i>
              </div>
              4.8 (589 đánh giá)
            </div>
            <p class="text-xs text-gray-400 mb-3 truncate">
              Quận 1, TP.HCM - Giao trong 20 phút
            </p>
            <div class="flex gap-2">
              <span
                class="bg-blue-50 text-blue-600 text-[10px] px-2 py-1 rounded-md"
                >Bún</span
              >
              <span
                class="bg-yellow-50 text-yellow-600 text-[10px] px-2 py-1 rounded-md"
                >Hủ tiếu</span
              >
            </div>
          </div>
        </div>

        <div
          class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden hover:shadow-md transition"
        >
          <div
            class="h-32 bg-gradient-to-r from-purple-900 to-fuchsia-900 relative p-4"
          >
            <span
              class="absolute top-3 right-3 bg-white text-red-500 text-[10px] font-bold px-2 py-1 rounded-full flex items-center gap-1"
              ><span class="w-1.5 h-1.5 bg-red-500 rounded-full"></span
              >ĐÓNG</span
            >
          </div>
          <div class="p-4">
            <h4 class="font-bold text-lg mb-1">Verdant Đà Nẵng</h4>
            <p class="text-xs text-gray-400 mb-3 truncate">
              Hải Châu, Đà Nẵng - Mở lại 7:00
            </p>
            <div class="flex gap-2">
              <span
                class="bg-purple-50 text-purple-600 text-[10px] px-2 py-1 rounded-md"
                >Lẩu</span
              >
            </div>
          </div>
        </div>
        <div
          class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden hover:shadow-md transition"
        >
          <div
            class="h-32 bg-gradient-to-r from-green-900 to-emerald-900 relative p-4"
          >
            <span
              class="absolute top-3 right-3 bg-white text-green-600 text-[10px] font-bold px-2 py-1 rounded-full flex items-center gap-1"
              ><span class="w-1.5 h-1.5 bg-green-500 rounded-full"></span
              >OPEN</span
            >
          </div>
          <div class="p-4">
            <h4 class="font-bold text-lg mb-1">Verdant Cần Thơ</h4>
            <p class="text-xs text-gray-400 mb-3 truncate">
              Ninh Kiều, Cần Thơ - Giao trong 30 phút
            </p>
            <div class="flex gap-2">
              <span
                class="bg-orange-50 text-orange-600 text-[10px] px-2 py-1 rounded-md"
                >Cơm tấm</span
              >
            </div>
          </div>
        </div>
      </div>
    </section>
  </body>
</html>
